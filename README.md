OSGCC-web
=========

This is a reboot of Joe Frambach's OSGCC site
(https://github.com/joeframbach/osgcc) since I didn't want to work in
Node.js.

Open Source Game Coding Competition registration, competition, and judging.

Front-end: Twitter Bootstrap

Back-end: Ruby + Sinatra + MongoDB

Authentication via Github OAuth

## Setup

bundle install

## The Idea

OSGCC admins will create a Competition model (name, start_time, end_time).

Users will log in via github and sign up for a competition. OSGCC will
generate a post-hook URL. All pushes to the user's git repo will post to
that url. OSGCC will log the user's commits throughout the competition to
ensure commits occur within the 24-hour period.

Need to figure out how to group several users in a single entry. Perhaps
have the users share a single unique post-hook URL.
