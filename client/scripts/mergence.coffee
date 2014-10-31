class Mergence
  constructor: ->
    @socket = io()
    @socket.on "change background", @changeBackgroundColor.bind(@)

    handleClick = ->
      @socket.emit "click"

    window.addEventListener "click", @handleClick.bind(@)
    window.addEventListener "touchstart", @handleClick.bind(@)

    @setBackgroundColor 'FFFFFF'

  handleClick: ->
    @socket.emit "click"

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
