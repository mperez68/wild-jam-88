@tool
class_name ActionTile extends PanelContainer

@onready var text_label: Label = %TextLabel
@onready var icon_texture: TextureRect = %IconTexture

@export var action: Car.Action = Car.Action.ACCELERATE:
	set(value):
		action = value
		if text_label and icon_texture:
			text_label.text = Car.Action.keys()[action].replace("_", " ")
			match action:
				Car.Action.ACCELERATE:
					icon_texture.texture.region.position.y = 256.0
				Car.Action.DECELERATE:
					icon_texture.texture.region.position.y = 192.0
				Car.Action.TURN_LEFT:
					icon_texture.texture.region.position.y = 128.0
				Car.Action.TURN_RIGHT:
					icon_texture.texture.region.position.y = 64.0

# ENGINE
func _ready():
	action = action


# PUBLIC


# PRIVATE


# SIGNALS
