@tool
class_name Car extends GridNode2D

@export var action_limit: int = 2
@export var acceleration_rate: int = 2
@export var deceleration_rate: int = 1
@export var friction: int = 2

var speed: Vector3i = Vector3i.ZERO
var actions: int = 2

# ENGINE
func _input(event: InputEvent) -> void:	# TODO temp
	if event.is_action_pressed("ui_accept"):
		end_actions()
	elif event.is_action_pressed("ui_up"):
		accelerate(acceleration_rate)
	elif event.is_action_pressed("ui_down"):
		decelerate(deceleration_rate)
	elif event.is_action_pressed("ui_left"):
		turn(false)
	elif event.is_action_pressed("ui_right"):
		turn(true)


# PUBLIC
func accelerate(value: int, cost: int = 1):
	speed += get_facing_vector_3d() * value
	do_action(cost)

func decelerate(value: int, cost: int = 1):
	speed -= get_facing_vector_3d() * value
	do_action(cost)

func turn(right: bool, cost: int = 1):
	var new_facing: int = (facing + (1 if right else -1)) % Facing.size()
	if new_facing < 0:
		new_facing += Facing.size()
	facing = (new_facing) as Facing
	do_action(cost)

func do_action(cost: int):
	actions -= cost
	if actions <= 0:
		end_actions()

func end_actions():
	if [Facing.UP, Facing.DOWN].has(facing):	# Vertical
		if speed.x < 0:
			speed.x = min(0, speed.x + friction)
		elif speed.x > 0:
			speed.x = max(0, speed.x - friction)
	else:										# Horizontal
		if speed.y < 0:
			speed.y = min(0, speed.y + friction)
		elif speed.y > 0:
			speed.y = max(0, speed.y - friction)
	grid_3d_position += speed
	actions = action_limit


# PRIVATE


# SIGNALS
