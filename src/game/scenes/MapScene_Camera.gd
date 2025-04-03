extends Camera2D

export(float, 1.0, 5.0) var CAMERA_SPEED := 2.0
export(float, 0.01, 0.2) var ZOOM_SPEED := 0.05
export(float, 0.5, 1.0) var MIN_ZOOM := 0.5
export(float, 1.0, 3.0) var MAX_ZOOM := 2.0
export(bool) var ZOOM_TO_POINTER := false
export(Rect2) var LIMIT_AREA := Rect2(0, 0, 1728*3, 864*3)

var target_position := position
var target_zoom := zoom

var is_dragging := false
var is_zooming := false
var touches := [false, false]
var touch_distance := 0.0

func _ready():
	return

func _input(event):

	if event is InputEventMouseButton:
		if event.pressed: touches[0] = event.position
		else: touches[0] = false

	if event is InputEventScreenTouch:
		if event.pressed:
			touches[event.index] = event.position
			touch_distance = 0.0
		else: touches[event.index] = false

	if event is InputEventScreenDrag:
        # Обновляем позицию касания
		touches[event.index] = event.position

	is_dragging = typeof(touches[0]) != TYPE_BOOL
	is_zooming = touches[0] && touches[1]

	if (!is_dragging && !is_zooming): return

	if is_zooming:

		var distance = touches[0].distance_to(touches[1])

		if touch_distance == 0.0:
			touch_distance = distance
		else:
			var zoom_factor = distance / touch_distance
			target_zoom /= zoom_factor
			target_zoom.x = clamp(target_zoom.x, MIN_ZOOM, MAX_ZOOM)
			target_zoom.y = clamp(target_zoom.y, MIN_ZOOM, MAX_ZOOM)
			target_zoom = clamp_zoom(target_zoom)
			touch_distance = distance
		# return

	# Перетаскивание камеры
	if is_dragging:
		if event is InputEventMouseMotion:
			set_target(target_position + (touches[0] - event.position) * vec2_camera_speed())
			touches[0] = event.position

	# Зум колесом мыши
	if event is InputEventMouseButton:

		if event.button_index == BUTTON_WHEEL_UP:
			target_zoom -= Vector2.ONE * ZOOM_SPEED
		if event.button_index == BUTTON_WHEEL_DOWN:
			target_zoom += Vector2.ONE * ZOOM_SPEED

		target_zoom.x = clamp(target_zoom.x, MIN_ZOOM, MAX_ZOOM)
		target_zoom.y = clamp(target_zoom.y, MIN_ZOOM, MAX_ZOOM)
		target_zoom = clamp_zoom(target_zoom)

		# Для зума к позиции мыши (опционально)
		if ZOOM_TO_POINTER and event.button_index in [BUTTON_WHEEL_UP, BUTTON_WHEEL_DOWN]:
			set_target(get_global_mouse_position())

func _physics_process(_delta):

	position = target_position
	zoom = lerp(zoom, target_zoom, 0.1)
	return

func vec2_camera_speed() -> Vector2:
	return Vector2.ONE * CAMERA_SPEED * zoom

func set_target(position: Vector2) -> void:

	var viewport = get_viewport_rect().size * zoom

	# target_position = position

	target_position.x = clamp(
		position.x,
		LIMIT_AREA.position.x + viewport.x / 2,
		LIMIT_AREA.end.x - viewport.x / 2
	)
	target_position.y = clamp(
		position.y,
		LIMIT_AREA.position.y + viewport.y / 2,
		LIMIT_AREA.end.y - viewport.y / 2
	)

func clamp_zoom(zoom: Vector2) -> Vector2:

	var viewport_size = get_viewport_rect().size
	var clamped = Vector2.ONE * min(
		LIMIT_AREA.size.x / viewport_size.x,
		LIMIT_AREA.size.y / viewport_size.y
	)

	return zoom if clamped.x >= zoom.x else clamped
