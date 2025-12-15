@tool
class_name FloatingText extends Control

@onready var label: Label = %Label
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export_multiline var text: String = "FLOATING TEXT":
	set(value):
		text = value
		if label:
			label.text = text
			label.position.x = -label.size.x / 2


# ENGINE
func _ready() -> void:
	if !Engine.is_editor_hint():
		animation_player.play("float")
		text = text


# PUBLIC


# PRIVATE


# SIGNALS
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "float":
		queue_free()
