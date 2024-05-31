extends Area2D
class_name Room

@onready var tile_map = $NavigationRegion2D/TileMap
@onready var collision_shape = $CollisionShape2D
@onready var enemy_container = $EnemyContainer
@onready var collectable_container = $CollectableContainer
@onready var navigation_region = $NavigationRegion2D
@onready var detector = $Detector
const tile_fire = preload("res://objects/MapObjects/Rooms/tile_fire.tscn")

var borders = Rect2(-500, -500, 1000, 1000)
var size : Vector2 = Vector2(7, 7);
var room_type : String = "normal"
var explored : bool = false
var used_positions = []
var door_positions = []
	
func create_room(pos, siz, room_typ):
	position = pos
	size = siz
	room_type = room_typ
	tile_map = $NavigationRegion2D/TileMap
	collision_shape = $CollisionShape2D
	enemy_container = $EnemyContainer
	collectable_container = $CollectableContainer
	navigation_region = $NavigationRegion2D
	detector = $Detector
	
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = size * 16
	collision_shape.shape = rect_shape
	
	create_tiles(position, size)
	if (room_type != "boss"):
		if (randi() % 10 < 2):
			create_special_tiles((-size/2).ceil() + Vector2(1, 1), size - Vector2(2, 2))
		if (room_type == "loot"):
			create_loot()
		elif (room_type == "walled"):
			create_walled()
		elif (room_type == "hole"):
			create_hole((-size/2).ceil() + Vector2(1, 1), size - Vector2(2, 2))
	navigation_region.bake_navigation_polygon()

func create_loot():
	tile_map.set_cell(0, Vector2(0, 0), 1, Vector2(4, 2))
	var collectable = ItemDrops.weapon_list[randi() % ItemDrops.weapon_list.size()][1].instantiate()
	collectable.position = Vector2(0, 0)
	collectable_container.add_child(collectable)
	
func create_tiles(pos, size):
	var top_left = (- size/2).ceil()
	var cells = []
	for y in size.y:
		for x in size.x:
			var room_cell_position = top_left + Vector2(x, y)
			if borders.has_point(room_cell_position):
				cells.append(room_cell_position)
	tile_map.set_cells_terrain_connect(0, cells, 1, 0)

func create_special_tiles(top_left, size):
	for y in range(1, size.y - 1):
		for x in range(1, size.x - 1):
			var room_cell_position = top_left + Vector2(x, y)
			if (randi() % 100 < 1):
				var new_tile = tile_fire.instantiate()
				new_tile.position = room_cell_position * 32
				collectable_container.add_child(new_tile)
				used_positions.append(room_cell_position)
	
func create_walled():
	var wall_cells = []
	for i in range(5, size.x - 3, 5):
		for j in range(3, size.y - 5):
			wall_cells.append(Vector2(ceili(-size.x / 2) + i, ceili(-size.y / 2) + j))
	tile_map.set_cells_terrain_connect(0, wall_cells, 1, 1)
	used_positions += wall_cells
	for i in range(5, size.x - 3, 5):
		for j in range(3, size.y - 5):
			if (randi() % 10 < 1):
				tile_map.set_cell(0, Vector2(ceili(-size.x / 2) + i, ceili(-size.y / 2) + j), 1, Vector2(1, 1))

func create_hole(top_left, size):
	var cells = []
	var hole_width = 3 + randi() % (floori(size.x/2) - 1)
	var hole_height = 3 + randi() % (floori(size.y/2) - 1)
	top_left += Vector2(1 + randi() % int(size.x - hole_width - 1), 1 + randi() % int(size.y - hole_height - 1))
	for y in range(0, hole_height):
		for x in range(0, hole_width):
			var hole_cell_position = top_left + Vector2(x, y)
			cells.append(hole_cell_position)
			used_positions.append(hole_cell_position)
	tile_map.set_cells_terrain_connect(0, cells, 2, 0)

func spawn_enemies():
	for i in range(door_positions.size()):
		for j in range(5):
			for k in range(5):
				used_positions.append(Vector2(door_positions[i] + Vector2(j - 2, k - 2)))
			
	if (room_type != "loot" and room_type != "first"):
		var temp = int(size.x * size.y / 100) * 2
		var more = temp * randi() % (temp + 1)
		var enemy_num = 5 + more
		
		var i = 0
		var sec = 0
		while i < enemy_num:
			var	spawn_pos_x = (randi() % int(size.x - 2)) - floor((size.x - 2)/2)
			var	spawn_pos_y = (randi() % int(size.y - 2)) - floor((size.y - 2)/2)
			if (!used_positions.has(Vector2(spawn_pos_x, spawn_pos_y))):
				var select_enemy_from_list = randi() % EnemySpawn.enemy_list.size()
				var new_enemy = EnemySpawn.enemy_list[select_enemy_from_list][1].instantiate()
				new_enemy.position = Vector2(spawn_pos_x, spawn_pos_y) * 32 + Vector2(12, 12)
				new_enemy.room_position = position - Vector2(floor((size.x - 2)/2), floor((size.y - 2)/2)) * 32
				new_enemy.room_size = (size - Vector2(2, 2)) * 32
				enemy_container.call_deferred("add_child", new_enemy)
				used_positions.append(Vector2(spawn_pos_x, spawn_pos_y))
			else:
				i -= 1
			i += 1
			sec += 1
			if sec > 100:
				break
				
func spawn_boss():
	var select_enemy_from_list = randi() % EnemySpawn.enemy_list.size()
	var new_enemy = EnemySpawn.enemy_list[select_enemy_from_list][1].instantiate()
	new_enemy.position = Vector2(0, 0) + Vector2(12, 12)
	new_enemy.room_position = position - Vector2(floor((size.x - 2)/2), floor((size.y - 2)/2)) * 32
	new_enemy.room_size = (size - Vector2(2, 2)) * 32
	enemy_container.call_deferred("add_child", new_enemy)
	
func _on_body_entered(body):
	print(room_type)
	SignalBus.emit_change_room_camera(position, size)
	if (!explored && room_type != "loot"):
		if (room_type == "boss"):
			spawn_boss()
		else:
			spawn_enemies()
		explored = true


func _on_body_exited(body):
	explored = false
	for i in enemy_container.get_children():
		i.queue_free()
	print("A")

func room():
	pass
