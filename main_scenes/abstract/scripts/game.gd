class_name Game extends Node2D

signal goalpost_cleared(final: bool)

@onready var map: Map = %Map

@export var level_name: String
@export_multiline var hint: String
#@export var 

var goalposts: Array[Goalpost]


# ENGINE
func _ready():
	for child in get_children():
		if child is Goalpost:
			goalposts.push_back(child)
	_update_next_goalpost()


# PUBLIC


# PRIVATE
func _update_next_goalpost():
	if !goalposts.is_empty():
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
