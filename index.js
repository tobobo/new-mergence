require('coffee-script/register')

var config = require('./config')();

var app = require('./app')(config);

app.get('start')();
