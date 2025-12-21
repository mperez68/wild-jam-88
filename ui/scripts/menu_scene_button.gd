@tool
class_name MenuSceneButton extends SceneButton

enum Scene{ QUIT, MAIN_MENU, LEVEL_SELECT, OPTIONS, CREDITS }

@export var next_scene: Scene:
	set(value):
		next_scene = value
		text = Scene.keys()[next_scene].capitalize()


# ENGINE
func _ready() -> void:
	if OS.get_name() == "Web" and next_scene == Scene.QUIT:
		hide()


# PUBLIC


# PRIVATE
func _get_scene(scene: Scene) -> PackedScene:
	var ret: PackedScene = null
	match scene:
		Scene.MAIN_MENU:
			ret = load("res://main_scenes/menus/main_menu.tscn")
		Scene.LEVEL_SELECT:
			ret = load("res://main_scenes/menus/level_select.tscn")
		Scene.OPTIONS:
			ret = load("res://main_scenes/menus/options.tscn")
		Scene.CREDITS:
			ret = load("res://main_scenes/menus/credits.tscn")
	return ret


# SIGNALS
func _on_pressed() -> void:
	target_scene = _get_scene(next_scene)
	if !target_scene:
		SceneManager.quit()
	super()
