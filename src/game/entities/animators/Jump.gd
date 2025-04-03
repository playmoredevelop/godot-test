tool
class_name Animator_Jump extends Node2D

export(float, 5, 100, 0.5) var height: float = 50.0
export(float, 0.1, 2.0, 0.1) var duration: float = 0.5

onready var tween := Tween.new()

func _ready() -> void:
	add_child(tween)
	start()
	return

# Настройка анимации вверх-вниз
func start() -> void:
	var yoyo_duration = duration / 2
	tween.interpolate_property(
		self,
		"position:y",
		0, -height,
		yoyo_duration,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	tween.interpolate_property(
		self,
		"position:y",
		- height, 0,
		yoyo_duration,
		Tween.TRANS_QUAD,
		Tween.EASE_IN,
		yoyo_duration
	)

	tween.repeat = true
	tween.start()
	return

func stop() -> void:
	tween.stop_all()

func _exit_tree():
	stop()
	remove_child(tween)
	tween.queue_free()