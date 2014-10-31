var socket = io();

var Mergence = function() {
  this.setBackgroundColor('FFFFFF');
}

Mergence.prototype.setBackgroundColor = function(color) {
  this.backgroundColor = color;
  document.body.style.backgroundColor = '#' + color;
}

Mergence.prototype.getBackgroundColor = function() {
  return this.backgroundColor;
}

Mergence.prototype.changeBackgroundColor = function() {
  if (this.backgroundColor == 'FFFFFF') {
    this.setBackgroundColor('000000');
  } else {
    this.setBackgroundColor('FFFFFF');
  }
}

var mergence = new Mergence();

socket.on('change background', mergence.changeBackgroundColor.bind(mergence));

var handleClick = function() {
  socket.emit('click');
}

window.addEventListener('click', handleClick);
window.addEventListener('touchstart', handleClick);
