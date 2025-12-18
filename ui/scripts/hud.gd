class_name Hud extends CanvasLayer

signal action_pressed(action: Car.Action, undo: bool)

const ACTION_TILE: PackedScene = preload("res://ui/action_tile.tscn")
const FLOATING_TEXT: PackedScene = preload("res://ui/floating_text.tscn")

@onready var action_tile_container: HBoxContainer = %ActionTileContainer
@onready var turn_timer_label: Label = %TurnTimerLabel
@onready var floatin_text_container: Control = %FloatinTextContainer
@onready var remaining_label: Label = %RemainingLabel
@onready var title_text: Label = %TitleText
@onready var description_text: Label = %DescriptionText
@onready var undo_button: SfxButton = %UndoButton

var action_limit: int = 2
var actions_queued: int = 0


# ENGINE
func _ready() -> void:
	_empty_action_tiles()
	SignalBus.end_game.connect(_on_end_game)


# PUBLIC
func set_text(header: String = "", body: String = ""):
	title_text.text = header
	description_text.text = body


# PRIVATE
func _empty_action_tiles():
	for child in action_tile_container.get_children():
		child.queue_free()
	actions_queued = 0
	_update_ap_label()

func _update_ap_label():
	remaining_label.text = str(action_limit - actions_queued)

func _disable_all_buttons(disable: bool, root: Node = self):
	for child in root.get_children():
		if child is Button:
			child.disabled = disable
		if !child is EndGameContainer:
			_disable_all_buttons(disable, child)


# SIGNALS
func _on_button_pressed(action: Car.Action) -> void:
	if action_tile_container.get_children().size() < action_limit:
		action_pressed.emit(action, false)
		var new_tile: ActionTile = ACTION_TILE.instantiate()
		new_tile.action = action
		action_tile_container.add_child(new_tile)
		actions_queued += 1
		undo_button.show()
	_update_ap_label()

func _on_undo_button_pressed() -> void:
	var children: Array[Node] = action_tile_container.get_children()
	if children.size() > 0:
		var removed_tile = children.pop_back()
		action_pressed.emit(removed_tile.action, true)
		removed_tile.queue_free()
		actions_queued -= 1
		if actions_queued == 0:
			undo_button.hide()
	_update_ap_label()

func _on_go_button_pressed() -> void:
	_empty_action_tiles()
	action_pressed.emit(Car.Action.DO_ACTIONS, false)
	undo_button.hide()

func _on_camera_button_toggled(toggled_on: bool) -> void:
	action_pressed.emit(Car.Action.CENTER_CAMERA, toggled_on)

func _on_game_goalpost_cleared(final: bool) -> void:
	if !final:
		var new_text: FloatingText = FLOATING_TEXT.instantiate()
		new_text.text = "GOALPOST\nCLEARED"
		floatin_text_container.add_child(new_text)

func _on_end_game(_turns: int, _par: Array[int]):
	_disable_all_buttons(true)

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
