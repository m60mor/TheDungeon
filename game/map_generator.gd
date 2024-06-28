extends Node
class_name MapGenerator

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var room_positions = []
var room_sizes = []
var base_room_size = [15, 15, 17, 17, 17, 19, 19, 19, 21]
var room_size : Vector2 = Vector2(7, 7)
var prev_room_size : Vector2 = Vector2(7, 7)

var room_manager : RoomManager = null;
var teleport_manager : TeleportManager = null;

func _init(starting_position, new_borders, steps):
	assert(new_borders.has_point(starting_position))
	borders = new_borders
	room_manager = RoomManager.new()
	teleport_manager = TeleportManager.new()
	create_room(position, "first", 0)
	walk(steps)

func is_not_room_at_position(pos):
	for i in range(room_positions.size()):
		if pos == room_positions[i]:
			return false
	return true
	
func get_farthest_room():
	var positive_farthest : Vector2 = room_positions.max()
	var negative_farthest : Vector2 = room_positions.min()
	return positive_farthest if positive_farthest.abs() > negative_farthest.abs() else negative_farthest

func walk(steps):
	var step_count = 1
	while step_count < steps:	
		if change_direction():
			var diff = round((float(step_count) / steps) * 5)
			if (diff < 1):
				diff = 1
			if (step_count == steps - 1):
				step("boss", diff)
			else:
				step("normal", diff)
		else:
			position = get_farthest_room()
			prev_room_size = room_sizes[room_positions.find(position)]
			step_count -= 1
		step_count += 1
	
	add_loot_rooms(steps, 10)
	room_manager.append_doors()
	return room_positions
	
func add_loot_rooms(steps, repeat):
	var loots = []
	var number = floori(steps / repeat)
	for x in range(number - 1):
		loots.append(repeat + (randi() % 1 + x * repeat) - 1)
	var i = 0
	while i < number - 1:
		prev_room_size = room_sizes[loots[i]]
		position = room_positions[loots[i]]
		if change_direction():
			step("loot")
			i += 1
		else:
			loots[i] += 1
	
func step(room_type : String = "normal", difficulty : int = 0):	
	var new_room_size = base_room_size[randi() % 9]
	if (room_type == "loot"):
		new_room_size = 7
	if (room_type == "boss"):
		new_room_size = 23
	room_size = Vector2(4 + new_room_size, new_room_size)
	var target_position = position + (direction * Vector2(30, 30))
	create_room(target_position, room_type, difficulty)
	create_door(position, target_position, prev_room_size, room_size)
	prev_room_size = room_size
	position = target_position
	
func change_direction():
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while borders.has_point(position + direction * 30) and is_not_room_at_position(position + direction * 30) == false:
		if (directions.is_empty()):
			return false
		direction = directions.pop_front()
	return true
		
func create_room(pos, room_type, difficulty):
	room_positions.append(pos)
	room_sizes.append(room_size)
	var size = room_size
	var top_left = (pos - size/2).ceil()
	room_manager.spawn_room(pos * 32, size, room_type, difficulty)
	
func create_door(position, target_position, prev_room_size, room_size):
	var prev_teleport_position = (position + direction * Vector2(int(prev_room_size.x / 2), int(prev_room_size.y / 2))) * 32 + Vector2(16, 16)
	var next_teleport_position = ((target_position - direction * Vector2(int(room_size.x / 2), int(room_size.y / 2))) * 32) + Vector2(16, 16)
	teleport_manager.spawn_teleport(prev_teleport_position, next_teleport_position, direction, room_manager.rooms[room_manager.rooms.size() - 2])
	teleport_manager.spawn_teleport(next_teleport_position, prev_teleport_position, -direction, room_manager.rooms[room_manager.rooms.size() - 1])
	var door_prev = floor(prev_teleport_position / 32) - room_positions[room_positions.size() - 2]
	var door_next = floor(next_teleport_position / 32) - room_positions[room_positions.size() - 1]
	#print(room_manager.rooms[room_manager.rooms.size() - 2].door_positions)
	room_manager.rooms[room_manager.rooms.size() - 2].door_positions.append(Vector2i(door_prev.x, door_prev.y))
	room_manager.rooms[room_manager.rooms.size() - 1].door_positions.append(Vector2i(door_next.x, door_next.y))
