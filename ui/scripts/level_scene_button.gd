@tool
class_name LevelSceneButton extends SceneButton

var category: String
var level: int = 0:
	set(value):
		level = value
		text = str(level)


# ENGINE


# PUBLIC
func set_level(scene: PackedScene):
	target_scene = scene
	tooltip_text = scene.get_state().get_node_property_value(0, 0)


# PRIVATE


# SIGNALS
func _on_pressed():
	super()
	SignalBus.start_game.emit(category, level)
