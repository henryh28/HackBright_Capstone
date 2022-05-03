""" Models definitions """

from flask_sqlalchemy import SQLAlchemy as db


# =============== Model definitions ===================
class User (db.Model):
    """ Define a User """
    __tablename__ = 'users'

    user_id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    first_name = db.Column(db.String)
    last_name = db.Column(db.String)
    user_name = db.Column(db.String)
    password = db.Column(db.String)
    email = db.Column(db.String, unique = True)


    # document related tables here

    def __repr__(self):
        """ Returns user info """
        return (f"<User user_id: {self.user_id} | first_name: {self.first_name} | last_name: {self.last_name} | username: {self.user_name} | email: {self.email}>")



# ================== Utility functions ===================

def connect_to_db(flask_app, db_uri = "postgresql:///hb_capstone", echo = True):
    flask_app.config["SQLALCHEMY_DATABASE_URI"] = db_uri
    flask_app.config["SQLALCHEMY_ECHO"] = echo
    flask_app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.app = flask_app
    db.init_app(flask_app)

    print ("   >>>>>>>>>>> Welcome to the Thunderdome <<<<<<<<<<   ")


if __name__ == "__main__":
    from server import app

    connect_to_db(app)


