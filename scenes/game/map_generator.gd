extends Node
class_name MapGenerator

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

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

func _init(starting_position, new_borders, steps):
	assert(new_borders.has_point(starting_position))
	room_positions.append(position)
	room_sizes.append(room_size)
	borders = new_borders
	room_manager = RoomManager.new()
	teleport_manager = TeleportManager.new()
	#create_room(position, "first")
	walk(steps)

func walk(steps):
	var step_count = 1
	var n = 0
	while step_count < steps:
		change_direction()
		
		if (step_count == steps - 1):
			n = 23
			
		if step(n):
			create_room(position, "normal")
			prev_room_size = room_size
			room_positions.append(position)
			room_sizes.append(room_size)
		else:
			change_direction()
			#step_count -= 1
		step_count += 1
	
	add_loot_rooms(floori(steps / 3))
	return room_positions
	
func add_loot_rooms(number):
	#fix infinite loop
	var i = 0
	var room_number = room_sizes.size()
	while i < number:
		var select = randi() % (room_number - 2) + 1
		prev_room_size = room_sizes[select]
		position = room_positions[select]
		for j in range(4):
			change_direction()
			if step(7):
				room_sizes.append(Vector2(7, 7))
				room_positions.append(position)
				create_room(position, "loot")
				i += 1
				break
	
func step(set_room_size : int = 0):
	var new_room_size = base_room_size[randi() % 9]
	if (set_room_size != 0):
		new_room_size = set_room_size
	room_size = Vector2(4 + new_room_size, new_room_size)
	var target_position = position + (direction * Vector2(30, 30))
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
		
func create_room(pos, room_type):
	var size = room_size
	var top_left = (pos - size/2).ceil()
	room_manager.spawn_room(pos * 32, size, room_type)
	
func create_door(position, target_position, prev_room_size, room_size):
	var prev_teleport_position = (position + direction * Vector2(int(prev_room_size.x / 2), int(prev_room_size.y / 2))) * 32 + Vector2(16, 16)
	var next_teleport_position = ((target_position - direction * Vector2(int(room_size.x / 2), int(room_size.y / 2))) * 32) + Vector2(16, 16)
	teleport_manager.spawn_teleport(prev_teleport_position, next_teleport_position, direction)
	teleport_manager.spawn_teleport(next_teleport_position, prev_teleport_position, -direction)
