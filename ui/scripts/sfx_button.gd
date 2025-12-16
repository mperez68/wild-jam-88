class_name SfxButton extends Button

@export var double_click: bool = false
@export var silent: bool = false

# ENGINE


# PUBLIC


# PRIVATE


# SIGNALS
func _on_pressed():
	if !silent:
		SfxManager.play_click(double_click)
