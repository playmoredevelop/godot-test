extends Node2D

var console = JavaScript.get_interface("console")
var document = JavaScript.get_interface("document")

func _ready():
	var canvas = document.getElementById('canvas')
	console.log(canvas)
	var callback = JavaScript.create_callback(self, 'listener')
	console.log(callback)
	canvas.addEventListener('touchstart', callback)

func listener(e):
	console.log(e)
	print(e)
	return
