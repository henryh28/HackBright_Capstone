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

@app.route ("/room/<room_url>")
def display_event(room_url):
    """ Renders an Event """

    print (" at room: ", room_url)

    return render_template("room.html")


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
        email = request.form['email']
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

# ================= API Related Routes =================

# Get API data
@app.route ("/search", methods = ["POST"])
def shows():
    """ Run API searches to find relevant data for choices """

    print ("=================== processing ==========================")
    type = request.form['type']
    title = request.form['title']
    print (" form search data: ", request.form)
    print ("type: ", type)
    title2 = "-".join(request.form['title'].split(" ")).lower()
    print (" title 2: : : : :  : ", title2)

    api_dict = {
        'movie': ["https://api.themoviedb.org/3/search/movie", {"api_key": TMDB_KEY, 'query': title}],
        'boardgame': ["https://api.boardgameatlas.com/api/search", {"client_id": BGATLAS_KEY, 'name': title}],
        'game': ["https://api.rawg.io/api/games", {"key": RAWG_KEY, 'search': title2, 'search_exact': True}]
    }

    api_url = api_dict[type][0]
    payload = api_dict[type][1]

    results = requests.get(api_url, params=payload)
    data = results.json()


    print ("   @@@ JSON data: ", data)


    return render_template("display.html", data = data)


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





if __name__ == "__main__":
    connect_to_db(app)
    app.run(host="0.0.0.0", debug = True)

