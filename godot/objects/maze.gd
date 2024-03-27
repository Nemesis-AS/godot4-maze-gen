extends Node2D

@export var debug: bool = true
@export var debug_time: float = 50 # Time in milliseconds
@export var grid_size: Vector2i = Vector2i(18, 11)
@export var cell_size: Vector2i = Vector2i(32, 32)

const COORD_MAP = {
	0: Vector2i(0, 0),
	1: Vector2i(1, 0),
	2: Vector2i(2, 0),
	3: Vector2i(3, 0),
	4: Vector2i(0, 1),
	5: Vector2i(1, 1),
	6: Vector2i(2, 1),
	7: Vector2i(3, 1),
	8: Vector2i(0, 2),
	9: Vector2i(1, 2),
	10: Vector2i(2, 2),
	11: Vector2i(3, 2),
	12: Vector2i(0, 3),
	13: Vector2i(1, 3),
	14: Vector2i(2, 3),
	15: Vector2i(3, 3),
}
var grid: Array = []

@onready var tilemap: TileMap = $TileMap
@onready var cursor: Sprite2D = $Cursor

func _ready() -> void:
	if debug:
		cursor.set_visible(true)
	
	randomize()
	generate()

func generate() -> void:
	grid = _generate_grid(grid_size)
	var stack: Array[Vector2i] = [Vector2i(0, 0)]
	
	while stack.size() > 0:
		var curr = stack[-1]
		var neighbors = _get_available_neighbours(curr)
		
		if debug:
			cursor.global_position = curr * cell_size
		
		if neighbors.size() == 0:
			stack.pop_back()
		else:
			var neighbor = neighbors[randi_range(0, neighbors.size() - 1)]
			match neighbor - curr:
				Vector2i.UP:
					grid[curr.y][curr.x] += 1
					grid[neighbor.y][neighbor.x] += 4
				Vector2i.RIGHT:
					grid[curr.y][curr.x] += 2
					grid[neighbor.y][neighbor.x] += 8
				Vector2i.DOWN:
					grid[curr.y][curr.x] += 4
					grid[neighbor.y][neighbor.x] += 1
				Vector2i.LEFT:
					grid[curr.y][curr.x] += 8
					grid[neighbor.y][neighbor.x] += 2
			
			# Update Grid
			tilemap.set_cell(0, curr, 0, COORD_MAP[grid[curr.y][curr.x]] * 2)
			tilemap.set_cell(0, neighbor, 0, COORD_MAP[grid[neighbor.y][neighbor.x]] * 2)
			
			stack.append(neighbor)
		
		# If debug is enabled
		if debug:
			await get_tree().create_timer(debug_time * 0.001).timeout
	
	cursor.set_visible(false)

func _generate_grid(size: Vector2i) -> Array:
	var arr: Array = []
	
	for y in range(size.y):
		var row: Array[int] = []
		for x in range(size.x):
			row.append(0)
			tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i.ZERO)
		arr.append(row)
	
	return arr

func _get_available_neighbours(curr: Vector2i) -> Array[Vector2i]:
	const OFFSETS: Array[Vector2i] = [Vector2i.DOWN, Vector2i.UP, Vector2i.RIGHT, Vector2i.LEFT]
	var av: Array[Vector2i] = []
	
	for offset in OFFSETS:
		var coord: Vector2i = Vector2i(curr.x + offset.x, curr.y + offset.y)
		
		# Check if the new coord is out of bounds!
		if (coord.x < 0 or coord.x >= grid_size.x or coord.y < 0 or coord.y >= grid_size.y):
			continue
		
		if grid[coord.y][coord.x] == 0:
			av.append(Vector2i(coord.x, coord.y))
	
	return av
