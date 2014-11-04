#server

_ = require 'underscore'

#/server

class BaseModel

BaseModel.computed = (dependencies..., obj) ->
  if typeof obj == 'function'
    get = obj
    set = (property, value) -> value
  else
    get = obj.get
    set = obj.set

  computed = get
  computed.get = get
  computed.set = set
  computed._computed = true
  computed.dependencies = dependencies

  computed

BaseModel.on = (eventNames..., fn) ->
  fn._on = true
  fn.eventNames = eventNames
  fn

BaseModel.observe = ->
  BaseModel.on.apply @, arguments

class Model extends BaseModel
  _handlers: {}

  constructor: (values) ->
    _.extend @, values
    @_bindEvents()
    @trigger 'init'

  _bindEvents: ->
    for key, value of @
      if value._on?
        @on value.eventNames..., value
      else if value._computed? and value.dependencies?
        @observe value.dependencies..., ((key, value, thisModel) ->
          ->
            value._cached = undefined
            _.bind(value.get, @)()
            thisModel.trigger key
        )(key, value, @)

  get: (property) ->
    value = @[property]

    if value?._computed == true
      if value._cached?
        value._cached
      else
        result = _.bind(value.get, @) property
        value._cached = result
    else
      value

  getProperties: (properties...) ->
    result = _.reduce properties, (memo, property) =>
      memo[property] = @get property
      memo
    , {}
    return result

  set: (property, value) ->
    objValue = @[property]
    if objValue?._computed == true
      result = _.bind(objValue.set, @) property, value
      objValue._cached = result
      result
    else
      @[property] = value
      value

    @trigger property

  setProperties: (obj) ->
    for key, value of obj
      @set key, value

  unset: (property) ->
    value = @[property]
    if value?._computed == true
      value._cached = undefined
      return
    else
      @[property] == undefined
      return

  bindHandler: (eventNames..., fn, handlerName) ->
    for eventName in eventNames
      handlers = @[handlerName][eventName] or []
      handlers.push fn
      @[handlerName][eventName] = handlers

  unbindHandler: (eventNames..., fn, handlerName) ->
    if eventNames.length == 0
      eventNames = [fn]
      fn = undefined
    for eventName in eventNames
      currentHandlers = @[handlerName][eventName] or []
      if fn?
        @[handlerName][eventName] = _.without(currentHandlers, fn)
      else
        @[handlerName][eventName] = []

  triggerHandler: (eventNames..., handlerName) ->
    for eventName in eventNames
      handlers = @[handlerName][eventName] or []
      for handler in handlers
        _.bind(handler, @)()
      return

  on: (eventNames..., fn) ->
    @bindHandler.call @, eventNames..., fn, '_handlers'

  off: (eventNames..., fn) ->
    @unbindHandler.call @, eventNames..., fn, '_handlers'

  trigger: (eventNames...) ->
    @triggerHandler.call @, eventNames..., '_handlers'

  observe: ->
    @on.apply @, arguments

module.exports = Model
