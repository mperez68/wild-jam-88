@abstract
class_name SceneButton extends SfxButton

var target_scene: PackedScene


# ENGINE


# PUBLIC


# PRIVATE


# SIGNALS
func _on_pressed():
	super()
	if target_scene:
		SceneManager.change_to_packed(target_scene)
	else:
		printerr("No scene set for %s (%s)!" % [name, text])
