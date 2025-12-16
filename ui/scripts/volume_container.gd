class_name VolumeContainer extends VBoxContainer

@onready var slider_map: Dictionary[String, HSlider] = {
	"Master": %MasterSlider,
	"Music": %MusicSlider,
	"Sfx": %SfxSlider
}


# ENGINE
func _ready():
	GameStateManager.load_game_state()
	for slider in slider_map.keys():
		slider_map[slider].value = GameStateManager.game_state.volumes[slider]

func _exit_tree() -> void:
	GameStateManager.save_game_state()


# PUBLIC


# PRIVATE


# SIGNALS
func _on_slider_value_changed(value: float, bus: String) -> void:
	GameStateManager.game_state.volumes[bus] = value
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus), value)
