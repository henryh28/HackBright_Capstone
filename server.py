""" Server for HackBright capstone project """

from hashlib import new
from flask import Flask, render_template, request, flash, session, redirect
from model import connect_to_db, db, User
from flask_session import Session
import jinja2, crud, os, requests



app = Flask(__name__)
app.secret_key = "temp"

TMDB_KEY = os.environ['TMDB_KEY']
STEAM_KEY = os.environ['STEAM_KEY']
BGATLAS_KEY = os.environ['BGATLAS_KEY']
RAWG_KEY = os.environ['RAWG_KEY']

# ================= System Related Routes =================

# Homepage
@app.route ("/")
def homepage():
    """ Displays homepage """

    if 'user' not in session:
        session['user'] = None
        session['user_name'] = None

    return render_template("index.html") 


@app.route ("/account", methods=["POST", "GET"])
def create_account():
    """ Allows for an user to create an account """

    if request.method == "POST":
        fname = request.form['fname']
        lname = request.form['lname']
        uname = request.form['uname']
        email = request.form['email']
        pw = request.form['password']

        new_user = crud.get_user_by(user_name=uname)
        if not new_user:
            new_user = crud.get_user_by(email=email)
            
        if new_user:
            flash("That user already exists")
        else:
            new_user = crud.create_user(fname, lname, uname, pw, email)
            db.session.add(new_user)
            db.session.commit()

        return redirect("/")
    else:
        return render_template("account.html")


@app.route ("/login", methods = ["POST"])
def login():
    """ Authenticates user for login """

    if request.method == "POST":
        uname = request.form['uname']
        pw = request.form['password']

        existing_user = crud.get_user_by(user_name=uname)

        if existing_user:
            if pw == existing_user.password:
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


# ================= Event/Room Related Routes =================

# Create a room
@app.route ("/create_room", methods = ["POST", "GET"])
def create_room():
    """ Create a room to host the users and choices for this event """

    if request.method == "POST":
        description = request.form['description']
        new_room = crud.create_event(description)
        db.session.add(new_room)
        db.session.commit()

        return redirect("/all_rooms")
    else:
        return render_template("room_create.html")


# Enter a specific room
@app.route ("/room/<room_code>")
def enter_room(room_code):
    """ Enter a specific room via provided room_code """
 
    room = crud.get_events_by(room_code = room_code)

    return render_template("room.html", room = room)


# ================= Choice Related Routes =================

# Display relevant info about a choice

@app.route ("/details/<item_code>")
def item_detail(item_code):
    """ View details regarding a speific choice """

    choice = crud.get_choice_by(choice_id = item_code)

    title = choice.title
    rawg_title = "-".join(title.split(" ")).lower()

    api_dict = {
        'movie': ["https://api.themoviedb.org/3/search/movie", {"api_key": TMDB_KEY, 'query': title}],
        'boardgame': ["https://api.boardgameatlas.com/api/search", {"client_id": BGATLAS_KEY, 'name': title}],
        'game': ["https://api.rawg.io/api/games", {"key": RAWG_KEY, 'search': rawg_title, 'search_exact': True}]
    }

    api_url = api_dict[choice.type][0]
    payload = api_dict[choice.type][1]

    
 
    results = requests.get(api_url, params=payload)
    data = results.json()

    print ("   @@@ JSON data: ", data)


    return render_template("item_details.html", choice = choice)

# ================= API Related Routes =================

# Get API data
@app.route ("/search", methods = ["GET", "POST"])
def shows():
    """ Run API searches to find relevant data for choices """

    if request.method == "POST":

        print ("=================== processing ==========================")
        type = request.form['type']
        title = request.form['title']
        rawg_title = "-".join(request.form['title'].split(" ")).lower()

        api_dict = {
            'movie': ["https://api.themoviedb.org/3/search/movie", {"api_key": TMDB_KEY, 'query': title}],
            'boardgame': ["https://api.boardgameatlas.com/api/search", {"client_id": BGATLAS_KEY, 'name': title}],
            'game': ["https://api.rawg.io/api/games", {"key": RAWG_KEY, 'search': rawg_title, 'search_exact': True}]
        }

        api_url = api_dict[type][0]
        payload = api_dict[type][1]

        results = requests.get(api_url, params=payload)
        data = results.json()

        print ("   @@@ JSON data: ", data)

        return render_template("display.html", data = data)
    else:
        return render_template("search.html")


@app.route ("/results/")
def display_data():
    """ Displays processed data for choices """



    return render_template("display.html")


# ================= Development Related Routes =================

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
    app.run(host="0.0.0.0", debug = True)

