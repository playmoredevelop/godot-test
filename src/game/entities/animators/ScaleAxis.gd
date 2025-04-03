tool
class_name Animator_ScaleAxis extends Node2D

export(float, 0.8, 1.5, 0.01) var min_scale := 1.0
export(float, 0.8, 1.5, 0.01) var max_scale := 1.2
export(float, 0.1, 2.0, 0.1) var duration := 1.0
export(float, 0.0, 0.5, 0.05) var axis_delay := 0.1

var target_scale := Vector2.ONE
var tween := Tween.new()
var is_playing := false

func _ready():
    add_child(tween)
    start()

func start():
	if is_playing: return

	target_scale = Vector2(min_scale, min_scale)
	is_playing = true

	var yoyo_duration := duration / 2

	# X axis animation
	tween.interpolate_property(self, "target_scale:x",
		min_scale, max_scale, yoyo_duration,
		Tween.TRANS_QUAD, Tween.EASE_OUT)

	# Y axis with delay
	tween.interpolate_property(self, "target_scale:y",
		min_scale, max_scale, yoyo_duration,
		Tween.TRANS_QUAD, Tween.EASE_OUT, axis_delay)

	# Return X
	tween.interpolate_property(self, "target_scale:x",
		max_scale, min_scale, yoyo_duration,
		Tween.TRANS_QUAD, Tween.EASE_IN, yoyo_duration)

	# Return Y with delay
	tween.interpolate_property(self, "target_scale:y",
		max_scale, min_scale, yoyo_duration,
		Tween.TRANS_QUAD, Tween.EASE_IN, yoyo_duration + axis_delay)

	tween.repeat = true
	tween.start()

func stop():
    is_playing = false
    tween.stop_all()
    target_scale = Vector2.ONE

func _physics_process(delta):
    scale = scale.linear_interpolate(target_scale, delta * 10)

func _exit_tree():
    tween.stop_all()
    remove_child(tween)
    tween.queue_free()