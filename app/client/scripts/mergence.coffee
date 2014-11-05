module.exports = (app) ->

  Model = require './common/model'

  class Mergence extends Model
    initSocket: Model.on 'init', ->
      @set 'socket', io()
      @get('socket').on "someone clicked", _.bind(@get('someoneClicked'), @)

    initTone: Model.on 'init', ->
      @set 'osc', new Tone.Oscillator(220, 'sawtooth')

      pitchBase = new Tone.Signal 220
      pitchLFO = new Tone.LFO 3, -2, 2
      pitchLFO.start()
      pitchBase.connect @get('osc').frequency
      pitchLFO.connect @get('osc').frequency

      pitchLFOLFO = new Tone.LFO 0.003, 0.01, 10
      pitchLFOLFO.start()
      pitchLFOLFO.connect pitchLFO.frequency

      lowpass = new Tone.Filter(600, 'lowpass')
      @get('osc').connect lowpass

      filterScale = new Tone.Scale(0, 1, 100, 1000)

      filterLFO = new Tone.LFO 0.0333, 5000, 15000
      filterMultiplier = new Tone.Multiply()
      filterLFO.connect filterMultiplier
      filterMultiplier.connect lowpass.frequency

      lfo2 = new Tone.LFO(0.025, -5000, 0)
      lfo2.start()
      lfo2.connect filterMultiplier


      lfo3 = new Tone.LFO(0.023, 0.025, 10)
      lfo2.oscillator = new Tone.Oscillator(0.023, 'square');
      lfo3.start()
      lfo3.connect lfo2.frequency

      filterLFO.start()

      @set 'envelope', new Tone.Envelope(0.5, 4.5, 0.15, 3)
      @get('envelope').connect @get('osc').output.gain
      lowpass.toMaster()
      @get('osc').start()

    triggerAttack: ->
      @get('envelope').triggerAttack()

    triggerRelease: ->
      @get('envelope').triggerRelease()

    initColor: Model.on 'init', ->
      @set 'backgroundColor', '000000'

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
      @triggerAttack()

      if @get 'noteOn'
        @clearNoteTimeout()
        @setNoteTimeout()
      else
        @set 'backgroundColor', 'FFFFFF'
        @set 'noteOn', true
        @setNoteTimeout()

    setNoteTimeout: ->
      noteTimeout = setTimeout =>
        @noteOn = false
        @triggerRelease();
        @set 'backgroundColor', '000000'
      , 15000
      @set 'noteTimeout', noteTimeout

    clearNoteTimeout: ->
      clearTimeout @get('noteTimeout')

    updateWindowBackgroundColor: Model.observe 'backgroundColor', ->
      document.body.style.backgroundColor = "##{@get('backgroundColor')}"


  return Mergence
