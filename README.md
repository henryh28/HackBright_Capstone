# HackBright Capstone Project &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; ![logo](static/img/ch_logo.png?raw=true")

BunnyBeenz is a platform that lets a group of people make decisions on what to do, faster so they spend more time doing and less time deciding.

## Features
+ User can create rooms using different voting methodology (Currently supports First Pass The Post and Random)
+ User can search for options to vote on and pull data from various APIs for boardgames, videogames, TV shows, and movies
+ Users in the same room can see real time update of available choices through the use of web sockets
+ User can chat with other users that are in the same room
+ For First Pass The Post rooms, users can view the current result of voting displayed in a variety of chart types using chart.js
+ Room owners can send SMS messages to invite users to their voting rooms

Techologies used:
**Backend** | Python, Flask, Postgresql, SQLAlchemy
**Frontend** | HTML, CSS, Javascript, Bootstrap, jQuery, chartJS
**API** | Boardgame Atlas, TMDB (The Movie Database), RAWG.io, Twilio
**Other** | Jinja, BCrypt, Paypal


#### Project Files

Filename | Description |
-------- | ----------- |
**/Static** | Static assets such as css, js, and image files
**/templates** | Jinja HTML templates
*.gitignore* | lists assests to not include in this repo
*README.md* | This file
*crud.py* | Contains definitions of CRUD functions for application models
*hb_capstone.sql* | .SQL file to populate sample database for this project
*model.py* | Contains definitions of database models
*requirements.txt* | Lists project dependencies
*seed_database.py* | Can be used to seed development database with testing data
*server.py* | Main server file that defines server route and functions


## Bugs
+ Drag & drop incompatibility with firefox browsers

## Contributing Author
*Henry Hsu* [Github](https://github.com/henryh28)

![My Spirit Animal](static/img/spirit_animal.jpg?raw=true")

License
Copyleft 2022. (Free for non-commercial use)  Contact my [lawyer](mailto:henrys.lawyer@gmail.com) for the details
