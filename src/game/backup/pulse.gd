@tool
extends Node2D

## Анимирование пульсации
class_name Animate_Pulse

@export_range(0.0, 2.0, 0.01) var from := 1.0
@export_range(0.0, 2.0, 0.01) var to := 1.05
@export_range(0.1, 2.0, 0.05) var timing := 0.3
@export var transition := Tween.TRANS_QUART
@export var easing := Tween.EASE_OUT

@export_group('Анимации')
@export_tool_button("animate_pulse", "Callable") var doAnimate = animate_pulse

func animate_pulse() -> Tween:
    self.scale = Vector2(from, from)
    var tween = create_tween()
    tween.set_ease(easing).set_trans(transition)
    tween.tween_property(self, "scale", Vector2(to, to), timing / 2)
    tween.tween_property(self, "scale", Vector2(from, from), timing / 2)
    return tween