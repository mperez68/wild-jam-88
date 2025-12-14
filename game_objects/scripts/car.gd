@tool
class_name Car extends GridNode2D

enum Action{ ACCELERATE, DECELERATE, TURN_LEFT, TURN_RIGHT, DO_ACTIONS, CENTER_CAMERA }

const MARKER: PackedScene = preload("res://game_objects/marker.tscn")

@onready var smoke_sprite: AnimatedSprite2D = %SmokeSprite

@export var acceleration_rate: int = 1
@export var deceleration_rate: int = 1
@export var max_speed: int = 8
@export var friction: int = 2

var next_position_marker: Marker
var speed: Vector3i = Vector3i.ZERO

# ENGINE


# PUBLIC
func accelerate(value: int, undo: bool = false):
	speed += get_facing_vector_3d() * value * (-1 if undo else 1)
	project_actions()

func decelerate(value: int, undo: bool = false):
	speed -= get_facing_vector_3d() * value * (-1 if undo else 1)
	project_actions()

func turn(right: bool, undo: bool = false):
	var new_facing: int = (facing + ( (1 if right else -1) * (-1 if undo else 1) )) % Facing.size()
	if new_facing < 0:
		new_facing += Facing.size()
	facing = (new_facing) as Facing
	project_actions()

func do_actions():
	smoke_sprite.play("puff")
	speed += _get_forces()
	var new_position: Vector3i = MyUtil.get_map().get_last_valid_to_target(grid_3d_position, grid_3d_position + speed)
	if new_position != grid_3d_position + speed:
		speed = Vector3i.ZERO
		# TODO sfx for crashing into walls
	grid_3d_position = new_position
	project_actions()

func project_actions():
	if next_position_marker:
		next_position_marker.queue_free()
	if _get_forces(true) == Vector3i.ZERO:
		return
	next_position_marker = MARKER.instantiate()
	next_position_marker.grid_3d_position = MyUtil.get_map().get_last_valid_to_target(grid_3d_position, grid_3d_position + _get_forces(true))
		
	add_sibling(next_position_marker)


# PRIVATE
func _get_forces(include_speed: bool = false) -> Vector3i:
	var total_forces: Vector3i = Vector3i.ZERO
	
	# Lateral Friction
	var tile: TileData = MyUtil.get_map().get_cell_tile_data(grid_3d_position)
	var is_frictionless: bool = tile and tile.get_custom_data("frictionless")
	
	if !is_frictionless:
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

func _center_camera(cancel: bool):
	SignalBus.center_camera.emit(null if cancel else self)


# SIGNALS
func _on_smoke_sprite_animation_finished() -> void:
	if smoke_sprite.animation == "puff":
		smoke_sprite.play("idle")

func _on_hud_action_pressed(action: Action, undo: bool) -> void:
	match action:
		Action.ACCELERATE:
			accelerate(acceleration_rate, undo)
		Action.DECELERATE:
			decelerate(deceleration_rate, undo)
		Action.TURN_LEFT:
			turn(false, undo)
		Action.TURN_RIGHT:
			turn(true, undo)
		Action.DO_ACTIONS:
			do_actions()
		Action.CENTER_CAMERA:
			_center_camera(undo)
