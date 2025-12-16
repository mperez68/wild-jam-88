extends Node

@onready var click: AudioStreamPlayer = %Click
@onready var double_click: AudioStreamPlayer = %DoubleClick

func play_click(is_double_click: bool):
	(double_click if is_double_click else click).play()
