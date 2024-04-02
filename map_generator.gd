extends Node
class_name MapGenerator

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var tile_map : TileMap = null
var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var base_room_size = [7, 9]
var room_size : float = 7
var prev_room_size : float = 7

func _init(starting_position, new_borders, new_tile_map):
	#assert(new_borders.has_point(starting_position))
	step_history.append(position)
	borders = new_borders
	tile_map = new_tile_map

func walk(steps):
	create_room(position)
	tile_map.set_cell(0, position, 2, Vector2(0, 0))
	for step in steps:
		change_direction()
			
		if step():
			step_history.append(position)
			tile_map.set_cell(0, position, 2, Vector2(0, 0))
			create_room(position)
		else:
			change_direction()
	return step_history
	
func step():
	prev_room_size = room_size
	room_size = base_room_size[randi() % 2]
	var target_position = position + (direction * (ceil(room_size / 2) + ceil(prev_room_size / 2) + 2))
	if borders.has_point(target_position) and tile_map.get_cell_source_id(0, target_position) == -1:
		var target_vector = target_position - position
		print(target_vector)
		for x in target_vector.x:
			print(x)
			tile_map.set_cell(0, Vector2(x, 0) + position, 2, Vector2(0, 0))
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false
	
func change_direction():
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()
		
func create_room(position):
	var size = Vector2(room_size, room_size)
	var top_left = (position - size/2).ceil()
	for y in size.y:
		for x in size.x:
			var new_step = top_left + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)
				tile_map.set_cell(0, new_step, 2, Vector2(0, 0))
