extends Node
class_name MapGenerator

#@onready var teleport_manager_scene = preload("res://scenes/managers/teleport_manager.tscn")
const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var tile_map : TileMap = null
var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var room_positions = []
var room_sizes = []
var base_room_size = [9, 9, 13, 13, 13, 15, 15, 15, 17]
var room_size : float = 7
var prev_room_size : float = 7

var room_manager : RoomManager = null;
var teleport_manager : TeleportManager = null;

func _init(starting_position, new_borders, new_tile_map):
	assert(new_borders.has_point(starting_position))
	room_positions.append(position)
	room_sizes.append(room_size)
	borders = new_borders
	tile_map = new_tile_map
	room_manager = RoomManager.new()
	teleport_manager = TeleportManager.new()
	create_room(position)

func walk(steps):
	var step = 1
	while step < steps:
		change_direction()
			
		if step():
			create_room(position)
			room_positions.append(position)
			room_sizes.append(room_size)
		else:
			change_direction()
			#step -= 1
		step += 1
	return room_positions
	
func step():
	room_size = base_room_size[randi() % 9]
	var target_position = position + (direction * (ceil(room_size / 2) + ceil(prev_room_size / 2) + 10))
	if borders.has_point(target_position) and tile_map.get_cell_source_id(0, target_position) == -1 and tile_map.get_cell_source_id(0, target_position + Vector2(room_size / 2, room_size / 2).ceil()) == -1 and tile_map.get_cell_source_id(0, target_position + Vector2(-room_size / 2, -room_size / 2).floor()) == -1 and tile_map.get_cell_source_id(0, target_position + Vector2(ceil(room_size / 2), floor(-room_size / 2))) == -1 and tile_map.get_cell_source_id(0, target_position + Vector2(floor(-room_size / 2), ceil(room_size / 2))) == -1:
		create_door(position, target_position, prev_room_size, room_size)
		position = target_position
		return true
	else:
		return false
	
func change_direction():
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()
		
func create_room(position):
	prev_room_size = room_size
	var size = Vector2(room_size, room_size)
	var top_left = (position - size/2).ceil()
	room_manager.spawn_room(position * 32, size)
	
	var cells = []
	for y in size.y:
		for x in size.x:
			var room_cell_position = top_left + Vector2(x, y)
			if borders.has_point(room_cell_position):
				cells.append(room_cell_position)
	tile_map.set_cells_terrain_connect(0, cells, 1, 0)
	if (randi() % 10 < 3):
		create_hole(top_left, size)

func create_hole(top_left, size):
	var cells = []
	var hole_width = 3 + randi() % (floori(size.x/2) - 1)
	var hole_height = 3 + randi() % (floori(size.y/2) - 1)
	top_left += Vector2(1 + randi() % int(size.x - hole_width - 1), 1 + randi() % int(size.y - hole_height - 1))
	for y in range(0, hole_height):
		for x in range(0, hole_width):
			var hole_cell_position = top_left + Vector2(x, y)
			cells.append(hole_cell_position)
	tile_map.set_cells_terrain_connect(0, cells, 2, 0)
	
func create_door(position, target_position, prev_room_size, room_size):
	print((position + direction * round(prev_room_size / 2)), "  ", ((target_position + (-direction * round(room_size / 2)))), " ", prev_room_size, " ", room_size)
	var prev_teleport_position = (position + direction * floori(prev_room_size / 2)) * 32
	var next_teleport_position = ((target_position - direction * floori(room_size / 2)) * 32)
	teleport_manager.spawn_teleport(prev_teleport_position, next_teleport_position, direction)
	teleport_manager.spawn_teleport(next_teleport_position, prev_teleport_position, -direction)
