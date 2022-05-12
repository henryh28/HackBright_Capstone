""" Create database & seed with data for development """

import os, json, model, server, crud
from datetime import datetime as dt

os.system('dropdb hb_capstone')
os.system('createdb hb_capstone')

model.connect_to_db(server.app)
model.db.create_all()


# ====== create sample users ==========
korra = crud.create_user('korra', 'korra', 'avatar', 'test', 'korra@test.com')
asami = crud.create_user('asami', 'sato', 'korrasami', 'test', 'asami@test.com')
max = crud.create_user('max', 'caulfield', 'mad_max', 'test', 'max@blackwell.edu')
chloe = crud.create_user('chloe', 'price', 'captain_chloe', 'test', 'chloe@arcadia.bay')
rachel = crud.create_user('rachel', 'amber', 'rach', 'test', 'rachel@blackwell.edu')

model.db.session.add_all([korra, asami, max, chloe, rachel])


# ====== create sample events ==========
vgame = crud.create_event("which video game?", "fptp")
bgame = crud.create_event("pick a boardgame!", "fptp")
movie = crud.create_event("what we watchin?", "fptp")

model.db.session.add_all([bgame, vgame, movie])


# ====== Link Users with event/rooms ==========
korra.events.append(vgame)
asami.events.append(vgame)
max.events.append(movie)
max.events.append(vgame)
chloe.events.append(movie)
rachel.events.append(movie)
chloe.events.append(bgame)
korra.events.append(bgame)


# ====== Create choices for events ==========
lis = crud.create_choice("vgame", "Life is Strange", 2)
fallout2 = crud.create_choice("vgame", "Fallout 2", 2)
kyrandia2 = crud.create_choice("vgame", "Kyrandia hand of fate", 2)
dune2 = crud.create_choice("vgame", "Dune-ii", 2)
lord = crud.create_choice("vgame", "legend of the red dragon", 2)

concordia = crud.create_choice("boardgame", "Concordia", 1)
stoneage = crud.create_choice("boardgame", "Stone age", 1)
viticulture = crud.create_choice("boardgame", "Viticulture: Essential Edition", 1)
spartacus = crud.create_choice("boardgame", "Spartacus: A Game of Blood and Treachery", 1)
machikoro = crud.create_choice("boardgame", "Machi Koro", 1)

gattaca = crud.create_choice("movie", "Gattaca", 3)
clerks = crud.create_choice("movie", "Clerks", 3)
your_name = crud.create_choice("movie", "Your Name", 3)

model.db.session.add_all([lis, fallout2, kyrandia2, dune2, lord, concordia, stoneage, viticulture, spartacus, machikoro, gattaca, clerks, your_name])

# ====== Create Votes for Choices ==========
chloe_game = crud.create_vote(1, 4, 7)
korra_game = crud.create_vote(1, 1, 8)
max_movie = crud.create_vote(1, 3, 9)
chloe_movie = crud.create_vote(1, 4, 10)
rachel_movie =crud.create_vote(1, 5, 10)
korra_food = crud.create_vote(1, 1, 3)
asami_food = crud.create_vote(1, 2, 1)
max_food = crud.create_vote(1, 3, 1)

model.db.session.add_all([chloe_game, korra_game, max_movie, chloe_movie, rachel_movie, korra_food, asami_food, max_food])



model.db.session.commit()


