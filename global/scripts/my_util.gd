extends Node

# CONSTANTS
const DEFAULT_WINDOW_DIMENSIONS: Vector2i = Vector2i(1280, 720)
const GRID_SIZE: Vector2 = Vector2(64, 64)
const CARDINAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT
]


# PUBLIC
func get_global_mouse_position() -> Vector2:
	return get_viewport().get_camera_2d().get_global_mouse_position()

func generate_shortcut(key: Key) -> Shortcut:
	var ret = Shortcut.new()
	ret.events.push_back(InputEventKey.new())
	ret.events.front().keycode = key
	return ret

#
func get_map(parent: Node = get_tree().current_scene) -> Map:
	if !parent:
		return
	if parent is Map:
		return parent
	for child in parent.get_children():
		var ret = get_map(child)
		if ret != null:
			return ret
	return null

#func get_positions_in_radius(position: Vector3i, radius: int) -> Array[Vector3i]:
	#if radius <= 0:
		#return [position]
	#var ret: Array[Vector3i] = []
	#var map: Map = get_map()
	#for x in range(position.x - radius, position.x + radius + 1):
		#for y in range(position.y - radius, position.y + radius + 1):
			#var temp: Vector3i = map.grid2d_to_grid3d(Vector2i(x, y)) + Vector3i.BACK
			#if temp.distance_to(position) <= radius:
				#if temp == position:
					#ret.push_front(temp)
				#else:
					#ret.push_back(temp)
	#return ret

#func get_turn_manager(parent: Node = get_tree().current_scene) -> TurnManager:
	#if !parent:
		#return
	#if parent is TurnManager:
		#return parent
	#for child in parent.get_children():
		#var ret = get_turn_manager(child)
		#if ret != null:
			#return ret
	#return null
