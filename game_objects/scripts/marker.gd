@tool
class_name Marker extends GridNode2D

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite

enum Icon{ CENTER, ARROW }

@export var icon: Icon = Icon.CENTER:
	set(value):
		icon = value
		_update_icon()

# ENGINE
func _ready():
	_update_icon()
	_update_face()


# PUBLIC


# PRIVATE
func _update_icon():
	if !animated_sprite:
		return
	match icon:
		Icon.CENTER:
			animated_sprite.play("center")
		Icon.ARROW:
			animated_sprite.play("arrow")

# SIGNALS
