class_name Camera extends Camera2D

@export var follow_target: Node2D
@export var pan_speed: float = 750.0
@export var locked: bool = false

var pan_vector: Vector2 = Vector2.ZERO

# ENGINE
func _ready() -> void:
	SignalBus.center_camera.connect(_on_center_camera)
	SignalBus.lock_camera.connect(_on_lock_camera)

func _process(delta: float) -> void:
	if locked:
		return
	if follow_target:
		if follow_target is Car:
			var temp := follow_target.position
			for marker in follow_target.next_position_markers:
				temp += marker.position
			temp = temp / (follow_target.next_position_markers.size() + 1)
			position = temp
			rotation = GridNode2D.facing_to_rad(follow_target.facing + 1)
		else:
			position = follow_target.position
			rotation = 0.0
	else:
		position += pan_vector * delta * pan_speed
		rotation = 0.0

func _input(event: InputEvent) -> void:
	if follow_target:
		return
	if event.is_action("pan_left") or event.is_action("pan_right") or event.is_action("pan_up") or event.is_action("pan_down"):
		pan_vector = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")


# PUBLIC


# PRIVATE


# SIGNALS
func _on_center_camera(node: Node2D):
	follow_target = node

func _on_lock_camera(is_locked: bool):
	locked = is_locked
