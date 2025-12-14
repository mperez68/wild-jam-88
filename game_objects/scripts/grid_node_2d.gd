@tool
class_name GridNode2D extends Node2D

enum Facing{ RIGHT, DOWN, LEFT, UP }

@export var grid_3d_position: Vector3i = Vector3i.ZERO:
	set(value):
		var new_pos = Vector2(value.x, value.y) * MyUtil.GRID_SIZE + (MyUtil.GRID_SIZE / 2)
		if position != new_pos:
			position = new_pos
		grid_3d_position = value
		z_index = value.z
@export var facing: Facing = Facing.RIGHT:
	set(value):
		facing = value
		_update_face()


# ENGINE
func _ready():
		if Engine.is_editor_hint():
			set_notify_transform(true)

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		grid_3d_position = Vector3i(floori(position.x / MyUtil.GRID_SIZE.x), floori(position.y / MyUtil.GRID_SIZE.y), grid_3d_position.z)


# PUBLIC
func get_facing_vector_3d(face: Facing = facing) -> Vector3i:
	var vector_2d: Vector2i = get_facing_vector_2d(face)
	return Vector3i(vector_2d.x, vector_2d.y, 0)

func get_facing_vector_2d(face: Facing = facing) -> Vector2i:
	match face:
		Facing.RIGHT:
			return Vector2i.RIGHT
		Facing.LEFT:
			return Vector2i.LEFT
		Facing.UP:
			return Vector2i.UP
		Facing.DOWN:
			return Vector2i.DOWN
		_:
			return Vector2i.ZERO

# STATIC PUBLIC
static func find_facing(start: Vector2, end: Vector2) -> Facing:
	var difference: float = (end - start).angle()
	if difference < 0:
		difference += 2 * PI
	if difference < PI / 4 or difference >= 7 * PI / 4:
		return Facing.RIGHT
	elif difference < 3 * PI / 4:
		return Facing.DOWN
	elif difference < 5 * PI / 4:
		return Facing.LEFT
	return Facing.UP

static func find_facing_grid_2d(start: Vector2i, end: Vector2i) -> Facing:
	return find_facing(Vector2(start), Vector2(end))

static func find_facing_grid_3d(start: Vector3i, end: Vector3i) -> Facing:
	return find_facing(Vector2(start.x, start.y), Vector2(end.x, end.y))


# PRIVATE
func _update_face():
	rotation = (PI / 2) * int(facing)


# SIGNALS
