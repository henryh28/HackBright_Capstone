""" Server for HackBright capstone project """

from hashlib import new
from multiprocessing.dummy import current_process
from flask import Flask, render_template, request, flash, session, redirect
from model import connect_to_db, db, User
import jinja2, crud, os, requests
from flask_bcrypt import Bcrypt
#from flask_session import Session


app = Flask(__name__)
app.secret_key = "temp"

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
        else:
            flash("Incorrect password")
    else:
        flash("Incorrect credentials")

    return redirect("/")

@app.route ("/logout")
def logout():
    """ Logs current user out of the system """

    session['user'] = None
    session['user_name'] = None

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
        if current_user.password == request.form['current_pw']:
            if request.form['new_pw'] == request.form['confirm_new_pw']:
                current_user.password = request.form['new_pw']
                db.session.add(current_user)
                db.session.commit()
                flash ("Password successfully changed!")
            else:
                flash ("'New Password' and 'Confirm New Password' value does not match!")
        else:
            flash ("Invalid password, calling the Feds.")

        return redirect(request.url)


# ================= Event/Room Related =================

# Create a room
@app.route ("/create_room", methods = ["POST", "GET"])
def create_room():
    """ Create a room to host the users and choices for this event """
    # GET method loads form for room creation
    # POST method processes form from room creation page

    if request.method == "POST":
        description = request.form['description']
        new_room = crud.create_event(description, request.form['voting_style'])
        db.session.add(new_room)
        db.session.commit()

        return redirect("/all_rooms")
    else:
        return render_template("room_create.html")


# Enter a specific room
@app.route ("/room/<room_code>", methods = ["POST", "GET"])
def enter_room(room_code):
    """ Enter a specific room via provided room_code """
 

    if request.method == "GET":
        room = crud.get_events_by(room_code = room_code)
        return render_template("room.html", room = room)
    else:
        room_code = request.form['room_code']
        room = crud.get_events_by(room_code = room_code)

        if room:
            return render_template("room.html", room = room)
        else:
            flash("Invalid room code")
            return redirect("/")

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

    title = itemData['choice_title']
    choice_type = itemData['choice_type']
    event_id = itemData['event_id']
    room_code = itemData['room_code']
    create_choice = itemData['create_choice']

    rawg_title = "-".join(title.split(" ")).lower()
    room = crud.get_events_by(room_code=room_code)
    details = []

#    print (f" &&&& title: {title} type: {choice_type} event_id: {event_id} room_code: {room_code} create_choice: {create_choice}")
#    choice_type, event_id, room_code, create_choice, title = (request.form.values())

    api_dict = {
        'movie': ["https://api.themoviedb.org/3/search/movie", {"api_key": TMDB_KEY, 'query': title}],
        'tv': ["https://api.themoviedb.org/3/search/tv", {"api_key": TMDB_KEY, 'query': title}],
        'boardgame': ["https://api.boardgameatlas.com/api/search", {"client_id": BGATLAS_KEY, 'name': title}],
        'vgame': ["https://api.rawg.io/api/games", {"key": RAWG_KEY, 'search': rawg_title}]
    }

    api_url = api_dict[choice_type][0]
    payload = api_dict[choice_type][1]

    results = requests.get(api_url, params=payload)
    data = results.json()

    if create_choice == "1":
        new_choice = crud.create_choice(choice_type, title, event_id)
        db.session.add(new_choice)
        db.session.commit()

        return redirect(f"/room/{room_code}")

    if choice_type == "movie":
        details = data['results']
#        poster_url = "https://image.tmdb.org/t/p/original" + details['poster_path']  // list slicing error for details['poster_path']
        return render_template("room.html", room = room, search_results = details, choice_type = choice_type)
    elif choice_type == "tv":
        for item in data['results']:
            details.append({"title": item['name']})

        return render_template("room.html", room = room, search_results = details, choice_type=choice_type)
    elif choice_type == "boardgame":
        for item in data['games']:
            details.append({"title": item['name']})

        return render_template("room.html", room = room, search_results = details, choice_type=choice_type)
    elif choice_type == "vgame":
        for item in data['results']:
            details.append({"title": item['name']})

        return render_template("room.html", room = room, search_results = details, choice_type=choice_type)


# Remove existing choice from a room/event
@app.route ("/remove_choice", methods = ["POST"])
def remove_choice():
    """ Remove the selected choice from the room """

    delete_target = crud.get_choice_by(choice_id = request.form['choice_id'])
    db.session.delete(delete_target)
    db.session.commit()

    return redirect(f"/room/{request.form['room_code']}")

# ================= Results Related =================
@app.route ("/submit_vote", methods = ["POST"])
def submit_vote():
    """ Process submitted votes """

    all_votes_for_choices = []
    room_code = request.form['room_code']
    vote_strength = request.form['vote_strength']
    user_id = session['user'] if session['user'] else None

    if 'choice_id' in request.form:
        choice_id = request.form['choice_id']
        vote = crud.create_vote(vote_strength, user_id, choice_id)
        db.session.add(vote)
        db.session.commit()

    room = crud.get_events_by(room_code = room_code)
    room_choices = room.choices #list

    for choices in room_choices:
        all_votes_for_choices.append(choices.votes)

    return render_template("results.html", room = room, room_choices=room_choices, all_votes_for_choices=all_votes_for_choices)



# ================= Development Related =================

# for testing
@app.route ("/test")
def test():
    """ feature testing """

    # replace with feature/code/function to test

    return render_template("test.html")


# list all rooms
@app.route ("/all_rooms")
def all_rooms():
    """ lists all events """
    all_events = crud.get_all_events()

    return render_template("all_rooms.html", all_events = all_events)


if __name__ == "__main__":
    connect_to_db(app)
    app.run(host="0.0.0.0", debug = False)

