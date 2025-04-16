class_name MassSpawner extends Node2D

export(PackedScene) var instance
export(int) var count = 10
export(Rect2) var area = Rect2(Vector2(0, 0), Vector2(100, 100))

func _ready() -> void:
	if not instance: return
	spawn()
	return

func spawn() -> void:
	for point in generate_points():
		var ins = instance.instance()
		ins.position = point
		self.add_child(ins)
	return

func generate_points() -> Array:
	var points = []
	var step_x = area.size.x / sqrt(count)
	var step_y = area.size.y / sqrt(count)
	var grid_size_x = int(ceil(area.size.x / step_x))
	var grid_size_y = int(ceil(area.size.y / step_y))

	for y in range(grid_size_y):
		for x in range(grid_size_x):
			if points.size() >= count: break
			var point_x = area.position.x + x * step_x + randi() % int(step_x)
			var point_y = area.position.y + y * step_y + randi() % int(step_y)
			points.append(Vector2(point_x, point_y))

	return points
