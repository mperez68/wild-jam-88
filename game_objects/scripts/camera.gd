class_name Camera extends Camera2D

@export var follow_target: Node2D
@export var pan_speed: float = 500.0
@export var locked: bool = false

var pan_vector: Vector2 = Vector2.ZERO

# ENGINE
func _process(delta: float) -> void:
	if locked:
		return
	if follow_target:
		position = follow_target.position
	else:
		position += pan_vector * delta * pan_speed

func _input(event: InputEvent) -> void:
	if follow_target:
		return
	if event.is_action("ui_left") or event.is_action("ui_right") or event.is_action("ui_up") or event.is_action("ui_down"):
		pan_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


# PUBLIC


# PRIVATE


# SIGNALS
