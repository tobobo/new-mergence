_ = require 'underscore'
path = require 'path'

fileListHelper = (list, base, stuff) ->
  if typeof stuff == 'string'
    list.push path.join(base, stuff)
  if _.isArray stuff
    for thing in stuff
      fileListHelper list, base, thing
  else if _.isObject stuff
    for key, thing of stuff
      fileListHelper list, path.join(base, key), thing

module.exports = (obj) ->
  list = []
  fileListHelper list, '', obj
  list
