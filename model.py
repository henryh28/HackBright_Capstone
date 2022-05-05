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

    # document related columns here

    events = db.relationship('Event', secondary = user_events, backref = 'participants')

    def __repr__(self):
        """ Returns user info """
        return (f"< User user_id: {self.user_id} | first_name: {self.first_name} | last_name: {self.last_name} | user_name: {self.user_name} | email: {self.email} >")



class Event (db.Model):
    """ Define an Event """
    __tablename__ = 'events'

    event_id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    room_location = db.Column(db.String)
    description = db.Column(db.String)

    # choices: all choices submitted for this event

    def __repr__(self):
        """ Returns event info """
        return (f"< Event event_id: {self.event_id} | room_location: {self.room_location} | description: {self.description} >")



class Choice (db.Model):
    """ Define a Choice """
    __tablename__ = 'choices'

    choice_id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    type = db.Column(db.String)
    title = db.Column(db.String)

    event_id = db.Column(db.Integer, db.ForeignKey("events.event_id"))
    event = db.relationship("Event", backref = "choices")

    # votes: all votes submitted for this choice

    def __repr__(self):
        """ Returns choice info """
        return (f"< Choice choice_id: {self.choice_id} | type: {self.type} | title: {self.title} | event: {self.event} >")



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


