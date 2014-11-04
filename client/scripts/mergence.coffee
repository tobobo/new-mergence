module.exports = (app) ->

  Model = require './shared/model'

  class Mergence extends Model
    initSocket: Model.on 'init', ->
      @set 'socket', io()
      @get('socket').on "someone clicked", _.bind(@get('someoneClicked'), @)

    initTone: Model.on 'init', ->
      @set 'envelope', new Tone.Envelope(0.05, 4.5, 0.15, 0.4)
      @set 'osc', new Tone.Oscillator(220, 'square')

      @get('envelope').connect @get('osc').output.gain

      @get('osc').toMaster()
      @get('osc').start()

    initColor: Model.on 'init', ->
      @set 'backgroundColor', 'FFFFFF'

    initClickEvents: Model.on 'init', ->
      window.addEventListener "click", @handleClick.bind(@)
      window.addEventListener "touchstart", @handleClick.bind(@)

    kickstartAudioContext: Model.on 'init', ->
      window.addEventListener 'touchstart', ->
        context = Tone.context
        buffer = context.createBuffer 1, 1, 22050
        source = context.createBufferSource()
        source.buffer = buffer
        source.connect context.destination
        source.noteOn 0
        source.noteOff 0
      , false

    handleClick: ->
      @get('socket').emit "click"

    someoneClicked: ->
      @toggleBackgroundColor()

      @get('envelope').triggerAttack()

      if @get 'noteOn'
        @clearNoteTimeout()
        @setNoteTimeout()
      else
        @set 'noteOn', true
        @setNoteTimeout()

    setNoteTimeout: ->
      noteTimeout = setTimeout =>
        @noteOn = false
        @get('envelope').triggerRelease();
      , 3000
      @set 'noteTimeout', noteTimeout

    clearNoteTimeout: ->
      clearTimeout @get('noteTimeout')

    toggleBackgroundColor: ->
      if @get('backgroundColor') == 'FFFFFF'
        @set 'backgroundColor', '000000'
      else
        @set 'backgroundColor', 'FFFFFF'

    updateWindowBackgroundColor: Model.observe 'backgroundColor', ->
      document.body.style.backgroundColor = "##{@get('backgroundColor')}"


  return Mergence
