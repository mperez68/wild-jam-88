class_name Map extends Node2D

const MAX_COORDINATE_SIZE: int = 3

var layers: Array[TileMapLayer]
var nav: AStar3D
var used_rect: Rect2i


# ENGINE
func _ready():
	pass
	var beginning: Vector2 = Vector2(9999, 9999)
	var end: Vector2 = Vector2.ZERO
	## Populate Layers
	for layer in get_children():
		if layer is TileMapLayer:
			layers.push_back(layer)
			var rect: Rect2i = layer.get_used_rect()
			beginning.x = min(beginning.x, rect.position.x)
			beginning.y = min(beginning.y, rect.position.y)
			end.x = max(end.x, rect.size.x + rect.position.x)
			end.y = max(end.y, rect.size.y + rect.position.y)
	used_rect = Rect2i(beginning, end - beginning)
	## Populate Navigation
	nav = AStar3D.new()
	for index in layers.size():
		for x in used_rect.size.x:
			for y in used_rect.size.y:
				var cell: TileData = layers[index].get_cell_tile_data(Vector2i(x, y))
				if cell:
					var pos: Vector3i = Vector3i(x, y, index)
					var id: int = _grid3d_to_id(pos)
					nav.add_point(id, Vector3(pos))
					# Connect to existing adjacent points
					if nav.has_point(_grid3d_to_id(pos + Vector3i.LEFT)):
						nav.connect_points(id, _grid3d_to_id(pos + Vector3i.LEFT))
					if nav.has_point(_grid3d_to_id(pos + Vector3i.DOWN)):
						nav.connect_points(id, _grid3d_to_id(pos + Vector3i.DOWN))


# PUBLIC
# Tightening getters
func local_to_grid2d(local_position: Vector2) -> Vector2i:
	return Vector2i(floori(local_position.x / float(MyUtil.GRID_SIZE.x)), floori(local_position.y / float(MyUtil.GRID_SIZE.y)))

func grid2d_to_grid3d(grid_position: Vector2i, top_layer: int = layers.size() - 1) -> Vector3i:
	for i in range(top_layer, -1, -1):
		if layers[i].get_cell_tile_data(grid_position):
			return Vector3i(grid_position.x, grid_position.y, i)
	return Vector3i.ZERO

func local_to_grid3d(local_position: Vector2) -> Vector3i:
	return grid2d_to_grid3d(local_to_grid2d(local_position))

# Loosening getters
func grid3d_to_grid2d(grid_position: Vector3i) -> Vector2i:
	return Vector2i(grid_position.x, grid_position.y)

func grid2d_to_local(grid_position: Vector2i) -> Vector2:
	return (Vector2(grid_position) * MyUtil.GRID_SIZE) + (MyUtil.GRID_SIZE / 2)
	
func grid3d_to_local(grid_position: Vector3i) -> Vector2:
	return grid2d_to_local(grid3d_to_grid2d(grid_position))

# cell data getters
func get_cell_tile_data(grid_position: Vector3i) -> TileData:
	return layers[grid_position.z].get_cell_tile_data(Vector2i(grid_position.x, grid_position.y))

func get_cell_tile_data_2d(grid_position: Vector2i) -> TileData:
	return layers[grid2d_to_grid3d(grid_position).z].get_cell_tile_data(Vector2i(grid_position.x, grid_position.y))

func get_cell_tile_data_local(local_position: Vector2) -> TileData:
	var grid_position: Vector3i = local_to_grid3d(local_position)
	return layers[grid_position.z].get_cell_tile_data(Vector2i(grid_position.x, grid_position.y))

func set_point_solid(pos: Vector3i, solid: bool = true):
	nav.set_point_disabled(_grid3d_to_id(pos), solid)

# Navigation
func get_route(start: Vector3i, end: Vector3i, length: int = 9999, start_inclusive: bool = false, end_inclusive: bool = true) -> Array[Vector3i]:
	if !nav.has_point(_grid3d_to_id(start)) or !nav.has_point(_grid3d_to_id(end)):
		return []
	var path := nav.get_point_path(_grid3d_to_id(start), _grid3d_to_id(end))
	var route_3d: Array[Vector3i] = []
	for point in path:
		route_3d.push_back(Vector3i(point))
	if !start_inclusive:
		route_3d.pop_front()
	if !end_inclusive:
		route_3d.pop_back()
	return route_3d.slice(0, length)

func can_walk(start: Vector3i, end: Vector3i, length: int = 9999) -> bool:
	if start == end:
		return true
	var route_length: int = get_route(start, end).size()
	return route_length > 0 and route_length <= length

func can_see(start: Vector3i, end: Vector3i, length: float = 9999.0) -> bool:
	return start.distance_to(end) <= length

func get_last_valid_to_target(start: Vector3i, end: Vector3i) -> Vector3i:
	var best: Vector3i = start
	var distance: int = abs(start.x - end.x) + abs(start.y - end.y) + abs(start.z - end.z)
	for i in distance + 1:
		var sub_diff: Vector3 = lerp(Vector3(start), Vector3(end), float(i) / float(distance))
		var closest_grid_3d: Vector3i = Vector3i(round(sub_diff.x), round(sub_diff.y), round(sub_diff.z))
		if get_cell_tile_data(closest_grid_3d):
			best = closest_grid_3d
	return best


# PRIVATE
func _grid3d_to_id(pos: Vector3i) -> int:
	var string: String = str(pos.x).pad_zeros(MAX_COORDINATE_SIZE) + str(pos.y).pad_zeros(MAX_COORDINATE_SIZE) + str(pos.z).pad_zeros(MAX_COORDINATE_SIZE)
	return string.to_int()

func _id_to_grid3d(id: int) -> Vector3i:
	var string: String = str(id).pad_zeros(MAX_COORDINATE_SIZE * 3)
	return Vector3i(string.substr(0, MAX_COORDINATE_SIZE).to_int(),
		string.substr(MAX_COORDINATE_SIZE, MAX_COORDINATE_SIZE).to_int(),
		string.substr(2 * MAX_COORDINATE_SIZE, MAX_COORDINATE_SIZE).to_int())


# SIGNALS
