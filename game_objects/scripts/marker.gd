@tool
class_name Marker extends GridNode2D

const TRANSPARENT: Color = Color(1.0, 1.0, 1.0, 0.6)

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite

enum Icon{ CENTER, ARROW, OBJECTIVE }

@export var icon: Icon = Icon.CENTER:
	set(value):
		icon = value
		_update_icon()

# ENGINE
func _ready():
	super()
	_update_icon()
	_update_face()


# PUBLIC


# PRIVATE
func _update_icon():
	if !animated_sprite:
		return
	animated_sprite.z_index = 1
	animated_sprite.self_modulate = Color.WHITE
	match icon:
		Icon.CENTER:
			animated_sprite.play("center")
		Icon.ARROW:
			animated_sprite.play("arrow")
		Icon.OBJECTIVE:
			animated_sprite.play("objective")
			animated_sprite.z_index = 0
			animated_sprite.self_modulate = TRANSPARENT
			

# SIGNALS
