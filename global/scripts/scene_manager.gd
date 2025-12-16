extends Node


# ENGINE


# PUBLIC
func change_to_packed(packed: PackedScene):
	call_deferred("_change_to_packed", packed)

func quit():
	get_tree().quit()


# PRIVATE
func _change_to_packed(packed: PackedScene):
	get_tree().change_scene_to_packed(packed)


# SIGNALS
