module.exports = class TimerSequence
  constructor: ->
    @total = 0
    @

  start: ->
    @_lastTime = new Date()
    @

  time: (name) ->
    now = new Date()
    diff = now - @_lastTime
    if name
      @[name] = @[name] or 0
      @[name] += diff
      
    @total += diff
    @_lastTime = now
    diff
