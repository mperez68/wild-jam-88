class_name DataResetButton extends SfxButton


# ENGINE


# PUBLIC


# PRIVATE


# SIGNALS
func _on_pressed() -> void:
	super()
	GameStateManager.reset_progress()
	get_tree().reload_current_scene()
