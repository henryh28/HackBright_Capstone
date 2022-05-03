""" Define CRUD operations for models """

from model import db, User, Event, Choice, Vote, connect_to_db
from datetime import datetime as dt

# ========== User related functions ==========

def create_user(fname, lname, uname, pw, email):
    """ Create and return a new User """
    return User(first_name=fname, last_name=lname, user_name=uname, password=pw, email=email)


def get_all_users():
    """ Returns a list of all Users in database """
    return User.query.all()


def get_user_by(**data):
    """ Search for and return a user by specified parameters """
    return User.query.filter_by(**data).first()

# ========== Event related functions ==========

def create_event(description):
    """ Create and return a new Event """

    room_url = "randomly_generated_room_id"

    return Event(room_location = room_url, description=description)


def get_all_events():
    """ Returns a list of all events in database """
    return Event.query.all()


def get_events_by(**data):
    """ Search for and return a event by specified parameters """
    return Event.query.filter_by(**data).first()

# ========== Choice related functions ==========

def create_choice(type, title, event_id):
    """ Create and return a new choice """

    return Choice(type = type, title = title, event_id = event_id)


def get_all_choices():
    """ Returns a list of all choices in database """
    return Choice.query.all()


def get_choice_by(**data):
    """ Search for and return a choice by specified parameters """
    return Choice.query.filter_by(**data).first()

# ========== Vote related functions ==========

def create_vote(amount, user_id, choice_id):
    """ Create and return a new vote """

    return Vote(amount = amount, user_id = user_id, choice_id = choice_id)


def get_all_votes():
    """ Returns a list of all votes in database """
    return Vote.query.all()


def get_vote_by(**data):
    """ Search for and return a vote by specified parameters """
    return Vote.query.filter_by(**data).first()


