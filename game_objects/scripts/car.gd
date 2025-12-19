@tool
class_name Car extends GridNode2D

signal car_moved(car: Car, start: Vector3i, end: Vector3i)

enum Action{ ACCELERATE, DECELERATE, TURN_LEFT, TURN_RIGHT, DO_ACTIONS, CENTER_CAMERA }

const MARKER: PackedScene = preload("res://game_objects/marker.tscn")

@onready var smoke_sprite: AnimatedSprite2D = %SmokeSprite
@onready var action_timer: Timer = %ActionTimer
@onready var move_sfx: AudioStreamPlayer2D = %MoveSfx
@onready var engine_sfx: Array[AudioStreamPlayer2D] = [%Engine1Sfx, %Engine2Sfx, %Engine3Sfx]
@onready var animation: AnimatedSprite2D = %Animation

@export var acceleration_rate: int = 1
@export var deceleration_rate: int = 1
@export var max_speed: int = 8
@export var debug_positions: bool = false

var next_position_markers: Array[Marker]
var follow_up_marker: Marker
var speed: Vector3i = Vector3i.ZERO
var action_queue: Array[Action] = []:
	set(value):
		action_queue = value
		if !action_queue.is_empty() and action_timer.is_stopped():
			action_timer.start()
		elif action_queue.is_empty():
			action_timer.stop()


# ENGINE
func _ready():
	super()
	if !Engine.is_editor_hint():
		SignalBus.end_game.connect(_on_end_game)


# PUBLIC
func accelerate(value: int, undo: bool = false):
	if !undo:
		animation.play("idle")
		animation.play("forward")
	speed += get_facing_vector_3d() * value * (-1 if undo else 1)
	project_actions()

func decelerate(value: int, undo: bool = false):
	if !undo:
		animation.play("idle")
		animation.play("slow")
	speed -= get_facing_vector_3d() * value * (-1 if undo else 1)
	project_actions()

func turn(right: bool, undo: bool = false):
	if !undo:
		animation.play("idle")
		animation.play("right" if right else "left")
	var new_facing: int = (facing + ( (1 if right else -1) * (-1 if undo else 1) )) % Facing.size()
	if new_facing < 0:
		new_facing += Facing.size()
	facing = (new_facing) as Facing
	project_actions()

func do_actions():
	smoke_sprite.play("puff")
	move_sfx.play()
	engine_sfx.pick_random().play()
	speed += _get_forces()
	var new_position: Vector3i = MyUtil.get_map().get_last_valid_to_target(grid_3d_position, grid_3d_position + speed)
	if new_position != grid_3d_position + speed:
		speed = Vector3i.ZERO
		# TODO sfx for crashing into walls
	car_moved.emit(self, grid_3d_position, new_position)
	grid_3d_position = new_position
	project_actions()
	if debug_positions:
		print(grid_3d_position)

func project_actions():
	for marker in next_position_markers:
		marker.queue_free()
	next_position_markers.clear()
	if follow_up_marker:
		follow_up_marker.queue_free()
	if _get_forces(true) == Vector3i.ZERO:
		return
	# Destination Marker
	next_position_markers.push_back(MARKER.instantiate())
	next_position_markers.front().grid_3d_position = MyUtil.get_map().get_last_valid_to_target(grid_3d_position, grid_3d_position + _get_forces(true))
	if next_position_markers.front().grid_3d_position != grid_3d_position + _get_forces(true):
		next_position_markers.push_back(MARKER.instantiate())
		next_position_markers.back().grid_3d_position = grid_3d_position + _get_forces(true)
		next_position_markers.back().modulate = Color.RED
	else:
		# Two Actions Away Marker
		follow_up_marker = MARKER.instantiate()
		follow_up_marker.grid_3d_position = next_position_markers.front().grid_3d_position + _get_forces(true, _get_forces(true), next_position_markers.front().grid_3d_position, facing)
		follow_up_marker.modulate = Color(0.529, 0.808, 0.922, 0.608)
		add_sibling(follow_up_marker)
	# Arrows
	for pos in MyUtil.get_map().get_route(grid_3d_position, next_position_markers.front().grid_3d_position, 9999, false, false):
		next_position_markers.push_back(MARKER.instantiate())
		next_position_markers.back().icon = Marker.Icon.ARROW
		next_position_markers.back().facing = find_facing_grid_3d(grid_3d_position, next_position_markers.front().grid_3d_position)
		next_position_markers.back().grid_3d_position = pos
	for marker in next_position_markers:
		add_sibling(marker)


# PRIVATE
func _get_forces(include_speed: bool = false, start_speed: Vector3i = speed, start_position: Vector3i = grid_3d_position, start_facing: Facing = facing) -> Vector3i:
	var total_forces: Vector3i = Vector3i.ZERO
	
	# Lateral Friction
	var tile: TileData = MyUtil.get_map().get_cell_tile_data(start_position)
	var friction: int = tile.get_custom_data("friction") if tile else 1

	if [Facing.UP, Facing.DOWN].has(start_facing):	# Vertical
		if start_speed.x < 0:
			total_forces.x = friction if start_speed.x + friction < 0 else -start_speed.x
		elif start_speed.x > 0:
			total_forces.x = -friction if start_speed.x - friction > 0 else -start_speed.x
	else:										# Horizontal
		if start_speed.y < 0:
			total_forces.y = friction if start_speed.y + friction < 0 else -start_speed.y
		elif start_speed.y > 0:
			total_forces.y = -friction if start_speed.y - friction > 0 else -start_speed.y
	
	return total_forces + (start_speed if include_speed else Vector3i.ZERO)

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

func _on_end_game(_turns: int, _par: Array[int]):
	_center_camera(true)
	speed = Vector3i.ZERO
	action_queue = [Action.TURN_RIGHT, Action.TURN_RIGHT, Action.TURN_RIGHT, Action.TURN_RIGHT,
			Action.TURN_RIGHT, Action.TURN_RIGHT, Action.TURN_RIGHT, Action.TURN_RIGHT]

func _on_action_timer_timeout() -> void:
	if !action_queue.is_empty():
		_on_hud_action_pressed(action_queue.pop_front(), false)

func _on_animation_animation_finished() -> void:
	if ["forward", "slow", "left", "right"].has(animation.animation):
		animation.play("idle")
