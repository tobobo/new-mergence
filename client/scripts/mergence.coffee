class Mergence
  constructor: ->
    @socket = io()
    @socket.on "someone clicked", @someoneClicked.bind(@)

    @initClickEvents()

    @initTone()

  initClickEvents: ->
    window.addEventListener "click", @handleClick.bind(@)
    window.addEventListener "touchstart", @handleClick.bind(@)

    window.addEventListener 'touchstart', ->
      myContext = new AudioContext()
      buffer = myContext.createBuffer 1, 1, 22050
      source = myContext.createBufferSource()
      source.buffer = buffer
      source.connect myContext.destination
      source.noteOn 0

  initTone: ->
    @env = new Tone.Envelope 0.05, 0.01, 0.25, 0.4
    @osc = new Tone.Oscillator 220, 'square'

    @setBackgroundColor 'FFFFFF'
    @env.connect @osc.output.gain

    @osc.toMaster()
    @osc.start()

  handleClick: ->
    @osc.start()
    @socket.emit "click"

  someoneClicked: ->
    @changeBackgroundColor()

    @env.triggerAttack();

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
    , 500

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

module.exports = Mergence
