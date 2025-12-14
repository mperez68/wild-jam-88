@tool
class_name Car extends GridNode2D

const MARKER: PackedScene = preload("res://game_objects/marker.tscn")


@export var action_limit: int = 2
@export var acceleration_rate: int = 2
@export var deceleration_rate: int = 1
@export var friction: int = 2

var next_position_marker: Marker
var speed: Vector3i = Vector3i.ZERO
var actions: int = 2

# ENGINE
func _input(event: InputEvent) -> void:	# TODO temp
	if event.is_action_pressed("ui_accept"):
		do_actions()
	elif event.is_action_pressed("ui_up"):
		accelerate(acceleration_rate)
	elif event.is_action_pressed("ui_down"):
		decelerate(deceleration_rate)
	elif event.is_action_pressed("ui_left"):
		turn(false)
	elif event.is_action_pressed("ui_right"):
		turn(true)


# PUBLIC
func accelerate(value: int):
	speed += get_facing_vector_3d() * value
	project_actions()

func decelerate(value: int):
	speed -= get_facing_vector_3d() * value
	project_actions()

func turn(right: bool):
	var new_facing: int = (facing + (1 if right else -1)) % Facing.size()
	if new_facing < 0:
		new_facing += Facing.size()
	facing = (new_facing) as Facing
	project_actions()


func do_actions():
	speed += _get_forces()
	grid_3d_position += speed
	actions = action_limit
	project_actions()

func project_actions():
	if next_position_marker:
		next_position_marker.queue_free()
	if _get_forces(true) == Vector3i.ZERO:
		return
	next_position_marker = MARKER.instantiate()
	next_position_marker.grid_3d_position = grid_3d_position + _get_forces(true)
	add_sibling(next_position_marker)


# PRIVATE
func _get_forces(include_speed: bool = false) -> Vector3i:
	var total_forces: Vector3i = Vector3i.ZERO
	# Lateral Friction
	if [Facing.UP, Facing.DOWN].has(facing):	# Vertical
		if speed.x < 0:
			total_forces.x = friction if speed.x + friction < 0 else -speed.x
		elif speed.x > 0:
			total_forces.x = -friction if speed.x - friction > 0 else -speed.x
	else:										# Horizontal
		if speed.y < 0:
			total_forces.y = friction if speed.y + friction < 0 else -speed.y
		elif speed.y > 0:
			total_forces.y = -friction if speed.y + friction > 0 else -speed.y
	return total_forces + (speed if include_speed else Vector3i.ZERO)


# SIGNALS
