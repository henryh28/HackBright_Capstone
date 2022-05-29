""" Define CRUD operations for models """

from secrets import choice
from model import db, User, Event, Choice, Vote, connect_to_db
from datetime import datetime as dt
import random

# ========== User related functions ==========

def create_user(fname, lname, uname, pw, email, chat_color="#223CC1", chat_bg_color="#FFFFFF"):
    """ Create and return a new User """
    return User(first_name=fname, last_name=lname, user_name=uname, password=pw, email=email, chat_color=chat_color, chat_bg_color=chat_bg_color)


def get_all_users():
    """ Returns a list of all Users in database """
    return User.query.all()


def get_user_by(**data):
    """ Search for and return a user by specified parameters """
    return User.query.filter_by(**data).first()

# ========== Event related functions ==========

def create_event(description, voting_style, admin_id, completed=False):
    """ Create and return a new Event """

    chars = 'abcdefghijklmnopqrstuvwxyz0123456789'
    room_code = None
    room_code_size = 4

    while room_code == None:
        temp_code = "".join(random.choices(chars, k = room_code_size))
        existing_room = get_events_by(room_code = temp_code)

        if not existing_room:
            room_code = temp_code

    return Event(room_code = room_code, voting_style=voting_style, description=description, admin_id=admin_id, completed=completed)


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


