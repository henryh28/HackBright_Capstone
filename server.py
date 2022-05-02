""" Server for HackBright capstone project """

from flask import Flask, render_template, request, flash, session, redirect
from model import connect_to_db, db
import jinja2

app = Flask(__name__)
app.secret_key = "temp"



# ================= System Related Routes


# Homepage
@app.route ("/")
def homepage():
    """ Displays homepage """

    return render_template("index.html")    


if __name__ == "__main__":
    connect_to_db(app)
    app.run(host="0.0.0.0", debug = True)

