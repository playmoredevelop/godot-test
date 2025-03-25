extends Node

@onready 
var wave_1: CPUParticles2D = $mask/wave1
@onready 
var wave_2: CPUParticles2D = $mask/wave2
@onready 
var wave_3: CPUParticles2D = $mask/wave3

func _ready() -> void:
    set_one_shot(true)
    set_emitting(false)

func set_emitting(v: bool) -> void:
    wave_1.emitting = v
    wave_2.emitting = v
    wave_3.emitting = v
    return

func set_one_shot(v: bool) -> void:
    wave_1.one_shot = v
    wave_2.one_shot = v
    wave_3.one_shot = v
    return

func animate_fire() -> void:
    set_one_shot(true)
    set_emitting(true)
    wave_2.restart()
    return
