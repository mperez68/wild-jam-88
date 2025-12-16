class_name Game extends Node2D

signal goalpost_cleared(final: bool)

@onready var map: Map = %Map
@onready var hud: Hud = %HUD

@export var level_name: String
@export_multiline var hint: String
@export var par: Array[int] = [5, 10, 15]

var goalposts: Array[Goalpost]
var turn_counter: int = 0:
	set(value):
		turn_counter = value
		hud.turn_timer_label.text = str(turn_counter)


# ENGINE
func _ready():
	MusicManager.play(MusicManager.Track.LEVEL)
	hud.set_text(level_name, hint)
	for child in get_children():
		if child is Goalpost:
			goalposts.push_back(child)
	_update_next_goalpost()


# PUBLIC


# PRIVATE
func _update_next_goalpost():
	if goalposts.is_empty():
		SignalBus.end_game.emit(turn_counter, par)
	else:
		goalposts.front().highlight(Goalpost.Highlight.HIGHLIGHT)


# SIGNALS
func _on_car_moved(car: Car, start: Vector3i, end: Vector3i) -> void:
	for point in map.get_route(start, end, 9999, true, true):
		if !goalposts.is_empty() and goalposts.front().points.has(point):
			goalposts.pop_front().queue_free()
			goalpost_cleared.emit(goalposts.is_empty())
			_on_car_moved(car, start, end)
			_update_next_goalpost()
			break

func _on_hud_action_pressed(action: Car.Action, _undo: bool) -> void:
	if action == Car.Action.DO_ACTIONS:
		turn_counter += 1
