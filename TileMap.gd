extends TileMap

@export var width: int = 15
@export var height: int = 8

const DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT,
]
const CALC_ID: int = 0
const TERRAIN_SET_ID: int = 0
const WALL_ID: int = 0


func initMaze() -> Array[Array]:
	var array: Array[Array] = []
	array.resize(height)
	for y in range(height):
		var line: Array[int] = []
		line.resize(width)
		for x in range(width):
			line[x] = 1
		array[y] = line
	return array


func isValidPosition(pos: Vector2i) -> bool:
	return pos.x > 0 and pos.x < width and pos.y > 0 and pos.y < height


func searchNextDirection(maze: Array[Array], pos: Vector2i) -> Vector2i:
	var directions = DIRECTIONS.duplicate()
	directions.shuffle()
	for direction in directions:
		var newPos = pos + direction * 2
		if isValidPosition(newPos) and maze[newPos.y][newPos.x] == 1 :
			return direction
	return Vector2i.ZERO


func generateMaze() -> Array[Array]:
	assert(width > 1 and height > 1, "ERROR: Maze width and height should be greater than one")

	var maze: Array[Array] = initMaze()
	var pos = Vector2i(1, 1)
	var stack = [pos]
	while not stack.is_empty():
		maze[pos.y][pos.x] = 0

		var nextDirection = searchNextDirection(maze, pos)
		if nextDirection == Vector2i.ZERO:
			pos = stack.pop_back()
			continue

		maze[(pos + nextDirection).y][(pos + nextDirection).x] = 0
		pos += nextDirection * 2
		stack.append(pos)

	maze[1][0] = 0
	maze[height - 2][width - 1] = 0

	return maze


func _ready():
	# add walls to size
	width = width * 2 + 1
	height = height * 2 + 1

	var maze: Array[Array] = generateMaze()

	var walls: Array[Vector2i] = []
	for y in maze.size():
		for x in maze[0].size():
			if maze[y][x] == 1:
				walls.append(Vector2i(x, y))

	set_cells_terrain_connect(CALC_ID, walls, TERRAIN_SET_ID, WALL_ID)
