extends TileMap

@export var width: int = 31
@export var height: int = 17

const DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT,
]
const LAYER_ID: int = 0
const WALL_TERRAIN_SET_ID: int = 0
const WALL_TILE_ID: int = 0
const FLOOR_TILE_ID: int = 1


func is_valid_position(pos: Vector2i) -> bool:
	return pos.x > 0 and pos.x < width and pos.y > 0 and pos.y < height


func search_next_direction(maze: Array[PackedInt32Array], pos: Vector2i) -> Vector2i:
	var directions: Array[Vector2i] = DIRECTIONS.duplicate()
	directions.shuffle()

	for direction in directions:
		var new_position: Vector2i = pos + direction * 2
		if is_valid_position(new_position) and maze[new_position.y][new_position.x] == 1 :
			return direction
	return Vector2i.ZERO


func init_maze() -> Array[PackedInt32Array]:
	var array: Array[PackedInt32Array] = []
	array.resize(height)
	for y in range(height):
		var line: PackedInt32Array = []
		line.resize(width)
		for x in range(width):
			line[x] = 1
		array[y] = line
	return array


func add_torch_item(coord: Vector2i):
	var torch_item: Area2D = preload("res://scenes/torch_item.tscn").instantiate()
	torch_item.position = map_to_local(coord)
	get_node("TorchItems").add_child(torch_item)


func generate_maze() -> Array[PackedInt32Array]:
	var maze: Array[PackedInt32Array] = init_maze()
	var pos = Vector2i(1, 1)
	var stack = [pos]
	while not stack.is_empty():
		maze[pos.y][pos.x] = 0

		var nextDirection = search_next_direction(maze, pos)
		if nextDirection == Vector2i.ZERO:
			if pos == stack[stack.size() - 1] and randi_range(0, 7) == 0:
				add_torch_item(pos)
			pos = stack.pop_back()
			continue

		maze[(pos + nextDirection).y][(pos + nextDirection).x] = 0
		pos += nextDirection * 2
		stack.append(pos)

	$Fish.position = Vector2(map_to_local(Vector2i(width - 2, height - 2)))
	return maze


func _ready() -> void:
	assert(width % 2 == 1, "width must be odd")
	assert(height % 2 == 1, "height must be odd")
	assert(width > 10, "width must be greater than 10")
	assert(height > 10, "height must be greater than 10")

	var maze: Array[PackedInt32Array] = generate_maze()

	var wall_cells: Array[Vector2i] = []
	for y in maze.size():
		for x in maze[0].size():
			if maze[y][x] == 1:
				wall_cells.append(Vector2i(x, y))
			else:
				set_cell(LAYER_ID, Vector2i(x, y), FLOOR_TILE_ID, Vector2i.ZERO)

	set_cells_terrain_connect(LAYER_ID, wall_cells, WALL_TERRAIN_SET_ID, WALL_TILE_ID, false)


func is_wall(coord: Vector2i) -> bool:
	return get_cell_source_id(LAYER_ID, coord) == WALL_TILE_ID
