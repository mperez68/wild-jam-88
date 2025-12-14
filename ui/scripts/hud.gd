class_name Hud extends CanvasLayer

signal action_pressed(action: Car.Action, undo: bool)

const ACTION_TILE: PackedScene = preload("res://ui/action_tile.tscn")

@onready var action_tile_container: VBoxContainer = %ActionTileContainer
@onready var turn_timer_label: Label = %TurnTimerLabel

var turn_counter: int = 0:
	set(value):
		turn_counter = value
		turn_timer_label.text = str(turn_counter)
var action_limit: int = 2
var action_queue: Array[Car.Action] = []


# ENGINE
func _ready() -> void:
	_empty_action_tiles()


# PUBLIC


# PRIVATE
func _empty_action_tiles():
	for child in action_tile_container.get_children():
		child.queue_free()


# SIGNALS
func _on_button_pressed(action: Car.Action) -> void:
	if action_tile_container.get_children().size() < action_limit:
		action_pressed.emit(action, false)
		var new_tile: ActionTile = ACTION_TILE.instantiate()
		new_tile.action = action
		action_tile_container.add_child(new_tile)
		action_tile_container.move_child(new_tile, 0)

func _on_undo_button_pressed() -> void:
	var children: Array[Node] = action_tile_container.get_children()
	if children.size() > 0:
		var removed_tile = children.pop_front()
		action_pressed.emit(removed_tile.action, true)
		removed_tile.queue_free()

func _on_go_button_pressed() -> void:
	_empty_action_tiles()
	action_pressed.emit(Car.Action.DO_ACTIONS, false)
	turn_counter += 1

func _on_camera_button_toggled(toggled_on: bool) -> void:
	action_pressed.emit(Car.Action.CENTER_CAMERA, toggled_on)
