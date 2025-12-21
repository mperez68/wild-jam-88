extends Node

const SAVE_PATH: String = "user://state.tres"

var game_state: GameState:
	get():
		if !game_state:
			game_state = GameState.new()
		return game_state
var current_level_category: String
var current_level_value: int


# ENGINE
func _ready():
	load_game_state()
	SignalBus.start_game.connect(_on_start_game)
	SignalBus.end_game.connect(_on_end_game)


# PUBLIC
func save_game_state():
	for volume in game_state.volumes:
		game_state.volumes[volume] = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(volume))
	ResourceSaver.save(game_state, SAVE_PATH)

func load_game_state():
	if ResourceLoader.exists(SAVE_PATH):
		game_state = ResourceLoader.load(SAVE_PATH)
		if !game_state:
			return false
	for volume in game_state.volumes:
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(volume), game_state.volumes[volume])
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if game_state.fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)

func reset_progress():
	game_state.level_progress.clear()
	save_game_state()


# PRIVATE


# SIGNALS
func _on_start_game(category: String, level: int):
	current_level_category = category
	current_level_value = level

func _on_end_game(turns: int, par: Array[int]):
	if turns <= par.back():
		game_state.level_progress[current_level_category] = max(current_level_value,
				game_state.level_progress[current_level_category] if game_state.level_progress.has(current_level_category) else 0)
	current_level_category = ""
	current_level_value = 0
	save_game_state()
