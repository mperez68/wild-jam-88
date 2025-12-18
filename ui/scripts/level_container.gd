@tool
class_name LevelContainer extends HBoxContainer

const BUTTON: PackedScene = preload("res://ui/level_scene_button.tscn")

@onready var title_label: Label = %TitleLabel
@onready var current_level: int = 0

@export var category: String:
	set(value):
		category = value
		if title_label:
			title_label.text = category
@export var levels: Array[PackedScene] = []:
	set(value):
		levels = value
		_on_levels_list_changed()


# ENGINE
func _ready():
	category = category
	#_on_levels_list_changed()

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		_clear_buttons()


# PUBLIC


# PRIVATE
func _on_levels_list_changed():
	if !Engine.is_editor_hint():
		current_level = GameStateManager.game_state.level_progress[category] if GameStateManager and GameStateManager.game_state.level_progress.has(category) else 0
	_clear_buttons()
	for i in levels.size():
		if levels[i]:
			var new_button: LevelSceneButton = BUTTON.instantiate()
			new_button.set_level(levels[i])
			new_button.category = category
			new_button.level = i + 1
			if i > current_level:
				new_button.disabled = true
			call_deferred("add_child", new_button)

func _clear_buttons():for child in get_children():
	if child is LevelSceneButton:
		child.queue_free()


# SIGNALS
