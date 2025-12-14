class_name Game extends Node2D

signal goalpost_cleared(final: bool)

@onready var map: Map = %Map

var goalposts: Array[Goalpost]


# ENGINE
func _ready():
	for child in get_children():
		if child is Goalpost:
			goalposts.push_back(child)


# PUBLIC


# PRIVATE


# SIGNALS


func _on_car_moved(car: Car, start: Vector3i, end: Vector3i) -> void:
	for point in map.get_route(start, end, 9999, true, true):
		if goalposts.front().points.has(point):
			goalposts.pop_front().queue_free()
			goalpost_cleared.emit(goalposts.is_empty())
			_on_car_moved(car, start, end)
			break
