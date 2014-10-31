RSVP = require 'rsvp'

config = require('./config') process.env.NODE_ENV or 'development'

app = require('./server/app') config

app.get('startServer')()
