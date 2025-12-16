class_name EndGameContainer extends PanelContainer

const PAR_CONTAINER: PackedScene = preload("res://ui/par_container.tscn")

@onready var par_container: HBoxContainer = %ParContainer


# ENGINE
func _ready() -> void:
	SignalBus.end_game.connect(_on_end_game)


# PUBLIC


# PRIVATE


# SIGNALS
func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_end_game(turns: int, par: Array[int]):
	for value in par:
		var new_container: ParContainer = PAR_CONTAINER.instantiate()
		par_container.add_child(new_container)
		par_container.move_child(new_container, 0)
		new_container.set_content(value, turns <= value)
	show()
