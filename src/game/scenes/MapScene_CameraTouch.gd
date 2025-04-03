extends Camera2D

# Настройки
export(bool) var use_touch = true
export(bool) var use_mouse = true
export(float) var drag_speed = 10.0
export(float) var smoothness = 5.0
export(float) var zoom_min = 0.5
export(float) var zoom_max = 2.0
export(float) var zoom_step = 0.5
export(float) var initial_zoom = 1.2 # Добавлена недостающая переменная
export(Rect2) var container

# Состояние
var target_pos = Vector2.ZERO
var target_zoom = 1.0
var drag_start = Vector2.ZERO
var is_dragging = false
var pinch_start = 0.0

func _ready():
	target_zoom = initial_zoom # Теперь используем экспортированную переменную
	position = get_init_position()
	target_pos = position
	zoom = Vector2.ONE * initial_zoom

func _process(delta):
    position = lerp(position, target_pos, smoothness * delta)
    zoom = lerp(zoom, Vector2(target_zoom, target_zoom), smoothness * delta)

func _input(event):
    # Обработка тача
    if use_touch:
        if event is InputEventScreenTouch:
            is_dragging = event.pressed and event.index == 0
            if is_dragging:
                drag_start = event.position
            else:
                pinch_start = 0.0 # Сброс при отпускании

        if event is InputEventScreenDrag and is_dragging:
            if event.index == 0:
                # Исправлено направление перемещения
                target_pos -= (event.position - drag_start) * drag_speed * target_zoom
                drag_start = event.position
            elif event.index == 1:
                handle_pinch(event)

    # Обработка мыши
    if use_mouse:
        if event is InputEventMouseButton:
            if event.button_index == BUTTON_LEFT:
                is_dragging = event.pressed
                if is_dragging:
                    drag_start = get_global_mouse_position()

            # Исправлены кнопки колеса
            if event.button_index == BUTTON_WHEEL_UP and event.pressed:
                target_zoom = clamp(target_zoom - zoom_step, zoom_min, zoom_max)
            elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
                target_zoom = clamp(target_zoom + zoom_step, zoom_min, zoom_max)

        if event is InputEventMouseMotion and is_dragging:
            # Исправлено направление перемещения
            target_pos -= (get_global_mouse_position() - drag_start) * drag_speed
            drag_start = get_global_mouse_position()

func handle_pinch(_event):
    var touch1 = get_viewport().get_screen_gesture_position(0)
    var touch2 = get_viewport().get_screen_gesture_position(1)
    if touch1 == Vector2.ZERO or touch2 == Vector2.ZERO: return

    var dist = touch1.distance_to(touch2)
    if pinch_start == 0.0:
        pinch_start = dist
    else:
        target_zoom = clamp(target_zoom * (pinch_start / dist), zoom_min, zoom_max)
        pinch_start = dist # Обновляем начальное расстояние

func get_init_position() -> Vector2:
	if !container: return self.position
	return container.size * 0.5 + container.position
