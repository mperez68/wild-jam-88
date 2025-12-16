@tool
class_name LevelSceneButton extends SceneButton




# ENGINE


# PUBLIC
func set_level(scene: PackedScene):
	target_scene = scene
	tooltip_text = scene.get_state().get_node_property_value(0, 0)


# PRIVATE


# SIGNALS
