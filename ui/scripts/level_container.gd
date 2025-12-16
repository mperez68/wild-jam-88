@tool
class_name LevelContainer extends HBoxContainer

const BUTTON: PackedScene = preload("res://ui/level_scene_button.tscn")

@onready var title_label: Label = %TitleLabel

@export var text: String:
	set(value):
		text = value
		if title_label:
			title_label.text = text
@export var levels: Array[PackedScene] = []:
	set(value):
		levels = value
		_on_levels_list_changed()


# ENGINE
func _ready():
	text = text


# PUBLIC


# PRIVATE
func _on_levels_list_changed():
	for child in get_children():
		if child is LevelSceneButton:
			child.queue_free()
	for i in levels.size():
		if levels[i]:
			var new_button: LevelSceneButton = BUTTON.instantiate()
			new_button.set_level(levels[i])
			new_button.text = str(i + 1)
			call_deferred("add_child", new_button)


# SIGNALS
