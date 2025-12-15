@tool
class_name Goalpost extends Node2D

const MARKER: PackedScene = preload("res://game_objects/marker.tscn")
const HL_MAP: Dictionary[Highlight, Color] = {
	Highlight.NONE: Color.WHITE,
	Highlight.HIGHLIGHT: Color.YELLOW,
	Highlight.LOWLIGHT: Color.DIM_GRAY,
}

enum Highlight{ NONE, HIGHLIGHT, LOWLIGHT }

@onready var line: Line2D = %Line

@export var start: Vector3i:
	set(value):
		start = value
		_update_line()
@export var end: Vector3i:
	set(value):
		end = value
		_update_line()

var points: Array[Vector3i]


# ENGINE
func _ready():
	if Engine.is_editor_hint():
		_update_line()
		return
	line.hide()
	var direction: GridNode2D.Facing = GridNode2D.find_facing_grid_3d(start, end)
	for point in MyUtil.get_map().get_route(start, end, 9999, true, true):
		var new_marker: Marker = MARKER.instantiate()
		new_marker.grid_3d_position = point
		points.push_back(point)
		new_marker.icon = Marker.Icon.OBJECTIVE
		new_marker.facing = direction
		add_child(new_marker)


# PUBLIC
func highlight(hl: Highlight):
	var new_color: Color = HL_MAP[hl]
	for marker in _get_markers():
		marker.modulate = new_color


# PRIVATE
func _get_markers() -> Array[Marker]:
	var markers: Array[Marker]
	for child in get_children():
		if child is Marker:
			markers.push_back(child)
	return markers

func _update_line():
	if line:
		line.points = [(Vector2(start.x, start.y) * MyUtil.GRID_SIZE) + (MyUtil.GRID_SIZE / 2), (Vector2(end.x, end.y) * MyUtil.GRID_SIZE) + (MyUtil.GRID_SIZE / 2)]


# SIGNALS
