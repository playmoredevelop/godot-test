extends Node
class_name Tap_Behaviour

signal on_tap_release(event: InputEventMouseButton, target: Node2D)

@export var target: Node2D

func _input(event: InputEvent) -> void:
	if not target: return
	if event is InputEventMouseButton and not event.is_pressed():
		on_tap_release.emit(event, target)