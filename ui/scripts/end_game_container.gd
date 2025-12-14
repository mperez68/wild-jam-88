class_name EndGameContainer extends PanelContainer


# ENGINE


# PUBLIC


# PRIVATE


# SIGNALS
func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()
