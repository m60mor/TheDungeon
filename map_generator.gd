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
var base_room_size = [11, 11, 13, 13, 13, 15, 15, 15, 17]
var room_size : Vector2 = Vector2(7, 7)
var prev_room_size : Vector2 = Vector2(7, 7)

var room_manager : RoomManager = null;
var teleport_manager : TeleportManager = null;

func is_not_room_at_position(pos):
	for i in range(room_positions.size()):
		if pos == room_positions[i]:
			return false
	return true

func _init(starting_position, new_borders, new_tile_map, steps):
	assert(new_borders.has_point(starting_position))
	room_positions.append(position)
	room_sizes.append(room_size)
	borders = new_borders
	tile_map = new_tile_map
	room_manager = RoomManager.new()
	teleport_manager = TeleportManager.new()
	create_room(position)
	walk(steps)

func walk(steps):
	var step_count = 1
	while step_count < steps:
		change_direction()
			
		if step():
			create_room(position)
			room_positions.append(position)
			room_sizes.append(room_size)
		else:
			change_direction()
			#step -= 1
		step_count += 1
	return room_positions
	
func step():
	var new_room_size = base_room_size[randi() % 9]
	room_size = Vector2(new_room_size, new_room_size - 2)
	var target_position = position + (direction * Vector2(30, 30))
	#var target_position = position + (direction * (ceil(room_size / 2) + ceil(prev_room_size / 2) + Vector2(10, 10)))
	if borders.has_point(target_position) and is_not_room_at_position(target_position):
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
		
func create_room(pos):
	prev_room_size = room_size
	var size = room_size
	var top_left = (pos - size/2).ceil()
	room_manager.spawn_room(pos * 32, size)
	
func create_door(position, target_position, prev_room_size, room_size):
	var prev_teleport_position = (position + direction * Vector2(int(prev_room_size.x / 2), int(prev_room_size.y / 2))) * 32 + Vector2(16, 16)
	var next_teleport_position = ((target_position - direction * Vector2(int(room_size.x / 2), int(room_size.y / 2))) * 32) + Vector2(16, 16)
	teleport_manager.spawn_teleport(prev_teleport_position, next_teleport_position, direction)
	teleport_manager.spawn_teleport(next_teleport_position, prev_teleport_position, -direction)
