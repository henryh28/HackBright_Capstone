""" Server for HackBright capstone project """

from argparse import Namespace
from hashlib import new
from multiprocessing.dummy import current_process
from flask import Flask, render_template, request, flash, session, redirect, copy_current_request_context, jsonify
from model import connect_to_db, db, User
import jinja2, crud, os, requests
from flask_bcrypt import Bcrypt
from flask_socketio import SocketIO, emit, join_room, leave_room
from flask_session import Session
from flask_babel import Babel
import eventlet
import json

#eventlet.monkey_patch()    #causes infinite recursion with requests.get to api
app = Flask(__name__)
#app.secret_key = "temp"
app.config['SECRET_KEY'] = "shanicus"
app.config['SESSION_TYPE'] = 'filesystem'

Session(app)

socketio = SocketIO(app, manage_session = False)

TMDB_KEY = os.environ['TMDB_KEY']
STEAM_KEY = os.environ['STEAM_KEY']
BGATLAS_KEY = os.environ['BGATLAS_KEY']
RAWG_KEY = os.environ['RAWG_KEY']


# ================= System Related  =================

# Homepage
@app.route ("/")
def homepage():
    """ Displays homepage """

    if 'user' not in session:
        session['user'] = None
        session['user_name'] = None
        session['room'] = None
        session['room_code'] = None
        session['user_chat_color'] = None
        session['user_chat_bg_color'] = None

    if session['user_name'] == None:
        session['user_name'] = 'Anonymous'
        session['user_chat_color'] = '#000000'
        session['user_chat_bg_color'] = '#ffffff'


    print (" init                   session           : ", session)

    return render_template("index.html") 

@app.route ("/login", methods = ["POST"])
def login():
    """ Authenticates user for login """

    uname = request.form['uname']
    pw = request.form['password']

    existing_user = crud.get_user_by(user_name=uname)

    if existing_user:
        if Bcrypt().check_password_hash(existing_user.password, pw):
            session['user'] = existing_user.user_id
            session['user_name'] = existing_user.user_name
            session['user_chat_color'] = existing_user.chat_color
            session['user_chat_bg_color'] = existing_user.chat_bg_color
        else:
            flash("Incorrect password")
    else:
        flash("Incorrect credentials")

    return redirect("/")

@app.route ("/logout")
def logout():
    """ Logs current user out of the system """

    session.clear()

#    session['user'] = None
#    session['user_name'] = None
#    session['room'] = None
#    session['room_code'] = None
#    session['user_chat_color'] = None
#    session['user_chat_bg_color'] = None


    return redirect("/")


@app.errorhandler(404)
def page_not_found(event):
    """ Custom error handler for 404 errors """

    return render_template("404.html")

# ================= User related  =================

@app.route ("/account", methods=["POST", "GET"])
def create_account():
    """ Allows for an user to create an account """
    # GET methods retrieves form for user account creation
    # POST method processes form from account creation

    if request.method == "POST":
        fname = request.form['fname']
        lname = request.form['lname']
        uname = request.form['uname']
        email = request.form['email']
        pw = request.form['password']

        existing_user_name = crud.get_user_by(user_name=uname)
        existing_email = crud.get_user_by(email=email)

        if existing_user_name:
            flash("That username is already in use")
        if existing_email:
            flash("That email is already in use")
            
        if not existing_email and not existing_user_name:
            hashed_password = Bcrypt().generate_password_hash(pw).decode('UTF-8')
            new_user = crud.create_user(fname, lname, uname, hashed_password, email)
            db.session.add(new_user)
            db.session.commit()

        return redirect("/")
    else:
        return render_template("account.html")


# View profile for current user
@app.route ("/view_user_profile", methods=["GET","POST"])
def view_user_profile():
    """ Display detailed info for the logged in user """
    # GET method displays user info
    # POST method processes user's change password request

    current_user = crud.get_user_by(user_id = session['user'])

    if request.method == "GET":
        return render_template("view_profile.html", user=current_user)    

    elif request.method == "POST":
        if Bcrypt().check_password_hash(current_user.password, request.form['current_pw']):
            if request.form['new_pw'] == request.form['confirm_new_pw']:
                current_user.password = Bcrypt().generate_password_hash(request.form['new_pw']).decode('UTF-8')
                db.session.add(current_user)
                db.session.commit()
                flash ("Password successfully changed!")
            else:
                flash ("'New Password' and 'Confirm New Password' value does not match!")
        else:
            flash ("Invalid password, calling the Feds.")

        return redirect(request.url)

@app.route ("/set_chat_color")
def set_chat_color():
    """ Sets chat color """

    current_user = crud.get_user_by(user_id = session['user'])
    new_color = f"#{request.args.get('color')}"
    current_user.chat_color = new_color
    db.session.commit()
    session['user_chat_color'] = new_color

    return redirect("/view_user_profile")

@app.route ("/set_chat_bg_color")
def set_chat_bg_color():
    """ Sets chat background color """

    current_user = crud.get_user_by(user_id = session['user'])
    new_color = f"#{request.args.get('color')}"
    current_user.chat_bg_color = new_color
    db.session.commit()
    session['user_chat_bg_color'] = new_color

    return redirect("/view_user_profile")

# ================= Event/Room Related =================

# Create a room
@app.route ("/create_room", methods = ["POST", "GET"])
def create_room():
    """ Create a room to host the users and choices for this event """
    # GET method loads form for room creation
    # POST method processes form from room creation page

    print (" %%%%%%%%%%%%%%% create room form = ", request.form)

    if request.method == "POST":
        description = request.form['description']
        admin_id = session['user'] if session['user'] != None else 0
        new_room = crud.create_event(description, request.form['voting_style'], admin_id)
        
        if request.form['voting_style'] == 'fptp':
            db.session.add(new_room)
            db.session.commit()
        elif request.form['voting_style'] == 'random':
            print (" --------> implement me (random event) <----------")
        elif request.form['voting_style'] == 'alternative':
            print ('  bernie!!!!!!!!!!!!!!!')
            return render_template("room_create.html", bernie=True)

        return redirect("/all_rooms")
    else:
        return render_template("room_create.html", bernie=False)


# Enter a specific room
@app.route ("/room/<room_code>", methods = ["POST", "GET"])
def enter_room(room_code):
    """ Enter a specific room via provided room_code """
    # GET method >> for development only. enters room directly. remove for production <<
    # POST method allows for user to join a room based on 4 character code

    if request.method == "POST":
        print (" ^^^^^^^^^^^^^^^^^^^^^^^^^^ ", request.form)
        room_code = request.form['room_code']

    room = crud.get_events_by(room_code = room_code)

    print (request.method, " >>>>>>>>>>>>>>>>>>> room : ", room)

    if room:
        session['room'] = room.event_id
        session['room_code'] = room_code
        username = session['user_name']
    else:
        flash("Invalid room code")
        return redirect("/")    

    print (session['room_code'], " >>>> code & id <<<< ", session['room'])
    print (username, "   ------- user name session : ", session['user_name'])
    print (session['user_chat_color'], "   &&&&&& color : ", session['user_chat_bg_color'])


    socketio.emit('status', {'msg': username + " joined this room"}, room = session['room'])
    return render_template("room.html", room = room, username=username)


#    if request.method == "GET":
#        
#        print (room, " $$$$$$$$$$$$$$$$$$$ GET room join: ", session['room'])
#        socketio.emit('status', {'msg': username + " joined this room"}, room = session['room'])
#
#        return render_template("room.html", room = room)
#    else:
#        socketio.emit('status', {'msg': username + " joined this room"}, room = session['room'])
#        return render_template("room.html", room = room)


@app.route ("/leave_room")
def leave_room():
    """ Remove user from joined room """

    session['room_code'] = None
    session['room'] = None

    return redirect("/")

@app.route ("/remove_event", methods=["POST"])
def remove_room():
    """ Remove a room from the database """

    remove_event = crud.get_events_by(event_id = request.form['event_id'])

    if session['user'] == remove_event.admin_id:
        db.session.delete(remove_event)
        db.session.commit()
        flash("room deleted!")
    else:
        flash("You're not authorized to delete this room")


    return redirect("/view_user_profile")



# list all rooms
@app.route ("/all_rooms")
def all_rooms():
    """ lists all events """
    all_events = crud.get_all_events()

    return render_template("all_rooms.html", all_events = all_events)


# ================= Choice Related =================

# Display relevant info about a choice
@app.route ("/details/<item_code>")
def item_detail(item_code):
    """ View details regarding a speific choice """

    choice = crud.get_choice_by(choice_id = item_code)
    title = choice.title
    rawg_title = "-".join(title.split(" ")).lower()
    details = []

    api_dict = {
        'movie': ["https://api.themoviedb.org/3/search/movie", {"api_key": TMDB_KEY, 'query': title}],
        'tv': ["https://api.themoviedb.org/3/search/tv", {"api_key": TMDB_KEY, 'query': title}],
        'boardgame': ["https://api.boardgameatlas.com/api/search", {"client_id": BGATLAS_KEY, 'name': title}],
        'vgame': ["https://api.rawg.io/api/games", {"key": RAWG_KEY, 'search': rawg_title}]
    }

    api_url = api_dict[choice.type][0]
    payload = api_dict[choice.type][1]

    results = requests.get(api_url, params=payload)
    data = results.json()

    if choice.type == "boardgame":
        details = data['games'][0]
        return render_template("item_details_bg.html", details = details)
    elif choice.type == "movie" or choice.type =="tv":
        details = data['results'][0]
        poster_url = "https://image.tmdb.org/t/p/original" + details['poster_path']
        return render_template("item_details_shows.html", details = details, poster_url = poster_url)
    elif choice.type == "vgame":
        title= data['results'][0]['slug']
        game_url = api_url + f"/{title}"
        game_data = requests.get(game_url, params={"key": RAWG_KEY})
        details = game_data.json()

        return render_template("item_details_vg.html", details = details)


# Adds a choice to a room/event
@app.route ("/add_choice", methods = ["POST"])
def add_choice():
    itemData = dict(request.form) if request.form else request.get_json()

    print (" ============ data : ", itemData)

    title = itemData['choice_title']
    choice_type = itemData['choice_type']
    event_id = itemData['event_id']
    room_code = itemData['room_code']
    create_choice = itemData['create_choice']  # 1 adds selected item as choice to room/event

    rawg_title = "-".join(title.split(" ")).lower()  # used for searching to rawg.io
    room = crud.get_events_by(room_code=room_code)
    details = []


    api_dict = {
        'movie': ["https://api.themoviedb.org/3/search/movie", {"api_key": TMDB_KEY, 'query': title}],
        'tv': ["https://api.themoviedb.org/3/search/tv", {"api_key": TMDB_KEY, 'query': title}],
        'boardgame': ["https://api.boardgameatlas.com/api/search", {"client_id": BGATLAS_KEY, 'name': title}],
        'vgame': ["https://api.rawg.io/api/games", {"key": RAWG_KEY, 'search': rawg_title}]
    }

    if choice_type != "custom":
        api_url = api_dict[choice_type][0]
        payload = api_dict[choice_type][1]

        results = requests.get(api_url, params=payload)
        data = results.json()

    # 1 adds selected item as choice to room/event
    if create_choice == "1":
        new_choice = crud.create_choice(choice_type, title, event_id)
        db.session.add(new_choice)
        db.session.commit()

        print (" &&&&&&&&& here we are :>>>>>>>>>> ", new_choice.as_dict())

        socketio.emit('update_choices', {'choice': new_choice.as_dict()}, room = session['room'])
#        socketio.emit('update_choices', {'room_code': room_code, 'choice': new_choice.as_dict()}, room = session['room'])

#        return redirect(f"/room/{room_code}")


    if choice_type == "movie":
#        poster_url = "https://image.tmdb.org/t/p/original" + details['poster_path']  // list slicing error for details['poster_path']
        for movie in data['results']:
            details.append({"data": [movie['title'], choice_type, event_id, room_code]})
        return jsonify(details)

    elif choice_type == "tv":
        for item in data['results']:
            details.append({"data": [item['name'], choice_type, event_id, room_code]})
        return jsonify(details)

    elif choice_type == "boardgame":
        for item in data['games']:
            details.append({"data": [item['name'], choice_type, event_id, room_code]})
        return jsonify(details)
#        return render_template("room.html", room = room, search_results = details, choice_type=choice_type)

    elif choice_type == "vgame":
        for item in data['results']:
            details.append({"data": [item['name'], choice_type, event_id, room_code]})
        return jsonify(details)

    elif choice_type == "custom":
        details.append({"data": [title, choice_type, event_id, room_code]})

        return jsonify(details)


# Remove existing choice from a room/event
@app.route ("/remove_choice", methods = ["POST"])
def remove_choice():
    """ Remove the selected choice from the room """

    delete_target = crud.get_choice_by(choice_id = request.form['choice_id'])
    print (session['user_name'], " &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& target: ", delete_target)
    db.session.delete(delete_target)
    db.session.commit()

    room = crud.get_events_by(event_id = session['room'])

    print (session['room'], " ********* delete from room: ", room)
    socketio.emit('refresh_room', {'room_code': room.room_code}, room = session['room'])

    return redirect(f"/room/{request.form['room_code']}")

# ================= Results Related =================
@app.route ("/submit_vote", methods = ["POST"])
def submit_vote():
    """ Process submitted votes """

    print (" &&&&&&&&&&&&& form: ", request.form)

#    all_votes_for_choices = []
    room_code = request.form['room_code']
    vote_strength = request.form['vote_strength']
    user_id = session['user'] if session['user'] else None
    chart_type = request.form['chart_type']
    results = {'chart_type': chart_type}

    if 'choice_id' in request.form:
        choice_id = request.form['choice_id']
        print (" ((((((( choice id: ", choice_id)
        vote = crud.create_vote(vote_strength, user_id, choice_id)
        print (" ??? vote : ", vote)
        db.session.add(vote)
        db.session.commit()

    room = crud.get_events_by(room_code = room_code)
    room_choices = room.choices #list

#    for choices in room_choices:
#        all_votes_for_choices.append(choices.votes)

    for choice in room_choices:
        results[choice.title] = len(choice.votes)

#    return render_template("results.html", room = room, room_choices=room_choices, all_votes_for_choices=all_votes_for_choices, data=data)
    return render_template("results.html", room = room, results=results, chart_type=chart_type)



# ================= Development Related =================

# for testing
@app.route ("/test", methods = ["GET", "POST"])
def test():
    """ feature testing """

    return render_template("test.html")

@app.route ("/react_test")
def react_test():
    """ testing react features"""

    return render_template("react_test.html")

# ================= SocketIO Related =================

'''
@socketio.on('connect')
def connected():
    print ("------- connected ----------")
    username = session['user_name'] if session['user_name'] != None else "Anonymous"
    emit('my_response', {'username': username, 'data': " joined this room !"})
'''


@socketio.on('disconnect')
def disconnected():
    print ("------- disconnected ---------- ")

@socketio.on('custom_event')
def custom_event(message):
    print (request.sid, " --------  custom event --- ", message)

@socketio.on('join')
def on_join(message):
    print (request.sid, " >>> join event msg: ", message)
    username = session['user_name']
    room = session['room']

    join_room(room)
    print (username, " >>> socket join event <<< ", room)
    emit('status', {'msg': username + " joined this room"}, room = room)

@socketio.on('message')
def handle_message(message):
    chatroom_id = session['room']
    username = session['user_name']
    print (type(message['data']), " =========== msg event: ", message)


    if session['user_chat_color'] == None:
        flash (" tell henry that the chat color setting is broken")
        session['user_chat_color'] = 'black'


    emit('my_response', {'username': username, 'data': message['data'], 'chat_color': session['user_chat_color'], 'chat_bg_color': session['user_chat_bg_color']}, room = chatroom_id) #room is reserved keyword
#    emit('my_response', {'username': username, 'data': message['data']}, room = room, callback = messageReceived)


def messageReceived():
    print ("  &&&&&&&&& callback function triggered")

# @socketio.on('chat')
# def handle_chat(message):
#  
#     print (request.sid, " >>>>>>>>>>> am i here? ", message)
#     username = session['user_name'] if session['user_name'] != None else "Anonymous"
#     room = session['room']
# #    socketio.send(".... socket send msg", json, callback=messageReceived)
#     emit('my_response', {'username': username, 'data': message['data']}, room = room, callback = messageReceived)

@socketio.on('my_broadcast_event')
def test_broadcast_message(message):
    emit('my_response', {'data': message['data']}, broadcast = True)

@socketio.on('disconnect_request')
def disconnect_request():

    print (" >>>>> disconnect request ")
    @copy_current_request_context
    def can_disconnect():
        print ("disconnecting <<<<<<")
        socketio.disconnect()

    emit('my_response', {'data': 'Disconnected'}, callback = can_disconnect)



if __name__ == "__main__":
    connect_to_db(app)
    #app.run(host="0.0.0.0", debug = True)
    socketio.run(app, debug = True)

