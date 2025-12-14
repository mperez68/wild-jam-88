@tool
class_name ActionTile extends PanelContainer

@onready var text_label: Label = %TextLabel

@export var action: Car.Action = Car.Action.ACCELERATE:
	set(value):
		action = value
		if text_label:
			text_label.text = Car.Action.keys()[action].replace("_", " ")


# ENGINE
func _ready():
	action = action


# PUBLIC


# PRIVATE


# SIGNALS
