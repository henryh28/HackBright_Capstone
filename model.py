""" Models definitions """

from flask_sqlalchemy import SQLAlchemy


db = SQLAlchemy()

# =============== Model definitions ===================

# Association table for Users & Events
user_events = db.Table('user_events', 
    db.Column('user_id', db.Integer, db.ForeignKey('users.user_id')),
    db.Column('event_id', db.Integer, db.ForeignKey('events.event_id'))
)



class User (db.Model):
    """ Define a User """
    __tablename__ = 'users'

    user_id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    first_name = db.Column(db.String)
    last_name = db.Column(db.String)
    user_name = db.Column(db.String, unique = True)
    password = db.Column(db.String)
    email = db.Column(db.String, unique = True)
    chat_color = db.Column(db.String)
    chat_bg_color = db.Column(db.String)

    # document related columns here

    events = db.relationship('Event', secondary = user_events, backref = 'participants')

    def __repr__(self):
        """ Returns user info """
        return (f"< User user_id: {self.user_id} | first_name: {self.first_name} | last_name: {self.last_name} | user_name: {self.user_name} | email: {self.email} >")

    def as_dict(self):
        """ Returns object's attribute as a dictionary """
        return { entry.name: getattr(self, entry.name) for entry in self.__table__.columns }



class Event (db.Model):
    """ Define an Event """
    __tablename__ = 'events'

    event_id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    room_code = db.Column(db.String, unique = True)
    voting_style = db.Column(db.String)
    description = db.Column(db.String)
    winner = db.Column(db.Integer, default = None)
    completed = db.Column(db.Boolean, default = False)

    # choices: all choices submitted for this event
    # participants: all users that submitted choices for the event

    admin_id = db.Column(db.Integer, db.ForeignKey("users.user_id"))
    admin = db.relationship("User", backref = "rooms")

    def __repr__(self):
        """ Returns event info """
        return (f"< Event event_id: {self.event_id} | room_code: {self.room_code} | voting_style: {self.voting_style} | description: {self.description} | winner: {self.winner} | completed: {self.completed} >")

    def as_dict(self):
        """ Returns object's attribute as a dictionary """
        return { entry.name: getattr(self, entry.name) for entry in self.__table__.columns }



class Choice (db.Model):
    """ Define a Choice """
    __tablename__ = 'choices'

    choice_id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    type = db.Column(db.String)
    title = db.Column(db.String)
    art = db.Column(db.String)

    event_id = db.Column(db.Integer, db.ForeignKey("events.event_id"))
    event = db.relationship("Event", backref = "choices")

    # votes: all votes submitted for this choice
    # admin: the User that created the room

    def __repr__(self):
        """ Returns choice info """
        return (f"< Choice choice_id: {self.choice_id} | type: {self.type} | title: {self.title} >")

    def as_dict(self):
        """ Returns object's attribute as a dictionary """
        return { entry.name: getattr(self, entry.name) for entry in self.__table__.columns }


class Vote (db.Model):
    """ Define a Vote """
    __tablename__ = 'votes'

    vote_id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    amount = db.Column(db.Integer)

    user_id = db.Column(db.Integer, db.ForeignKey("users.user_id"))
    choice_id = db.Column(db.Integer, db.ForeignKey("choices.choice_id"))
    user = db.relationship("User", backref = "votes")
    choice = db.relationship("Choice", backref = "votes")


    def __repr__(self):
        """ Returns vote info """
        return (f"< Vote vote_id: {self.vote_id} | amount: {self.amount} | user: {self.user} | choice: {self.choice} >")

    def all_votes_by_user(self, user_id):
        """ Returns all votes by a specific user """

    def as_dict(self):
        """ Returns object's attribute as a dictionary """
        return { entry.name: getattr(self, entry.name) for entry in self.__table__.columns }


# ================== Utility functions ===================

def connect_to_db(flask_app, db_uri = "postgresql:///hb_capstone", echo = True):
    flask_app.config["SQLALCHEMY_DATABASE_URI"] = db_uri
    flask_app.config["SQLALCHEMY_ECHO"] = False
    flask_app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.app = flask_app
    db.init_app(flask_app)

    print ("   >>>>>>>>>>> Welcome to the Thunderdome <<<<<<<<<<   ")


if __name__ == "__main__":
    from server import app

    connect_to_db(app)


