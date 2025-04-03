extends Area2D

export(Array, Resource) var resources := []
export var coins := 10

signal on_catch

onready var sprite: Sprite = $Animator_Jump/Animator_ScaleAxis/Sprite

func _ready():
	connect("input_event", self, "on_pressed")
	set_random_texture()

func set_random_texture() -> Texture:

	if resources.empty():
		return sprite.texture

	randomize()

	# Выбираем случайный ресурс
	var selected = resources[randi() % resources.size()]
	sprite.texture = selected

	return selected

func on_pressed(_vp: Node, event: InputEvent, _shape: int):
	if not event is InputEventMouseButton: return
	if event.is_pressed(): return
	printt('on_catch', coins, event.is_pressed())
	emit_signal("on_catch", coins)
	destroy()
	return

func destroy() -> void:
	self.queue_free()
	return
