class_name FullScreenButton extends SfxButton


# ENGINE
func _ready():
	if OS.get_name() == "web":
		hide()
	set_pressed_no_signal(GameStateManager.game_state.fullscreen)


# PUBLIC


# PRIVATE


# SIGNALS
	


func _on_toggled(toggled_on: bool) -> void:
	GameStateManager.game_state.fullscreen = toggled_on
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED)
