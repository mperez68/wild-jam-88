class_name PoliceDrone extends Node2D

const FRICTION: float = 0.4

@export var accel_speed: float = 1.0
@export var tolerance: float  = 32.0
@export var velocity: Vector2 = Vector2.ZERO
@export var target: Vector2 = Vector2.ZERO


# ENGINE
func _ready():
	call_deferred("_new_target")

func _physics_process(delta: float) -> void:
	if target != Vector2.ZERO:
		velocity += (target - position).normalized() * accel_speed * delta
	position += velocity * FRICTION
	if position.distance_to(target) < tolerance:
		_new_target()


# PUBLIC


# PRIVATE
func _new_target():
	if !MyUtil.get_map().is_node_ready():
		await MyUtil.get_map().ready
	var rect: Rect2i = MyUtil.get_map().used_rect
	var target_grid: Vector2i = Vector2i.ZERO
	target_grid.x = randi_range(0, rect.size.x)
	target_grid.y = randi_range(0, rect.size.y)
	target = MyUtil.get_map().grid2d_to_local(target_grid)


# SIGNALS
