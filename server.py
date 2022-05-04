""" Server for HackBright capstone project """

from flask import Flask, render_template, request, flash, session, redirect
from model import connect_to_db, db, User
import jinja2, crud, os, requests

app = Flask(__name__)
app.secret_key = "temp"

TMDB_KEY = os.environ['TMDB_KEY']
STEAM_KEY = os.environ['STEAM_KEY']
BGATLAS_KEY = os.environ['BGATLAS_KEY']

# ================= System Related Routes =================

# Homepage
@app.route ("/")
def homepage():
    """ Displays homepage """

    return render_template("index.html")    

@app.route ("/room/<room_url>")
def display_event(room_url):
    """ Renders an Event """

    print (" at room: ", room_url)


    return render_template("room.html")

@app.route ("/results/")
def display_data():
    """ Displays processed data for choices """



    return render_template("display.html")
# ================= API Related Routes =================

# Get TV & Movie data
@app.route ("/search", methods = ["POST"])
def shows():
    """ Run API searches to find relevant data for choices """

    print ("=================== processing ==========================")
    type = request.form['type']
    title = request.form['title']
    print (" form search data: ", request.form)
    print ("type: ", type)

    api_dict = {
        'movie': ["https://api.themoviedb.org/3/search/movie", {"api_key": TMDB_KEY, 'query': title}],
        'boardgame': ["https://api.boardgameatlas.com/api/search", {"client_id": BGATLAS_KEY, 'name': title}]
    }

    api_url = api_dict[type][0]
    payload = api_dict[type][1]

    results = requests.get(api_url, params=payload)
    data = results.json()


    print ("   @@@ JSON data: ", data)


    return render_template("display.html", data = data)



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

