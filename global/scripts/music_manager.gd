extends Node

enum Track{ MENU, LEVEL }

@onready var menu_theme: Node = %MenuTheme
@onready var level_theme: Node = %LevelTheme


# PUBLIC
func play(track: Track):
	for key in Track.values():
		if track == key:
			_get_track(key).play()
		else:
			_get_track(key).stop()


# PRIVATE
func _get_track(track: Track) -> Song:
	match track:
		Track.MENU:
			return menu_theme
		Track.LEVEL:
			return level_theme
		_:
			return null
