module.exports = (app) ->

  Model = require './shared/model'

  class Mergence
    constructor: ->
      @socket = io()
      @socket.on "someone clicked", @someoneClicked.bind(@)

      @initTone()
      @initClickEvents()
      @kickstartAudioContext()

    initTone: ->
      @env = new Tone.Envelope 0.05, 4.5, 0.15, 0.4
      @osc = new Tone.Oscillator 220, 'square'

      @setBackgroundColor 'FFFFFF'
      @env.connect @osc.output.gain

      @osc.toMaster()
      @osc.start()


    initClickEvents: ->
      window.addEventListener "click", @handleClick.bind(@)
      window.addEventListener "touchstart", @handleClick.bind(@)

    kickstartAudioContext: ->
      window.addEventListener 'touchstart', ->
        context = Tone.context
        buffer = context.createBuffer 1, 1, 22050
        source = context.createBufferSource()
        source.buffer = buffer
        source.connect context.destination
        source.noteOn 0
      , false

    handleClick: ->
      @osc.start()
      @socket.emit "click"

    someoneClicked: ->
      @changeBackgroundColor()

      @env.triggerAttack()

      if @noteOn
        @clearNoteTimeout()
        @setNoteTimeout()
      else
        @noteOn = true
        @setNoteTimeout()

    setNoteTimeout: ->
      @noteTimeout = setTimeout =>
        @noteOn = false
        @env.triggerRelease();
      , 3000

    clearNoteTimeout: ->
      clearTimeout @noteTimeout

    setBackgroundColor: (color) ->
      @backgroundColor = color
      document.body.style.backgroundColor = "##{color}"

    getBackgroundColor: ->
      @backgroundColor

    changeBackgroundColor: ->
      if @backgroundColor is 'FFFFFF'
        @setBackgroundColor '000000'
      else
        @setBackgroundColor 'FFFFFF'

  return Mergence
