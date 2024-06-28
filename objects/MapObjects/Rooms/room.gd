extends Area2D
class_name Room

@onready var tile_map = $NavigationRegion2D/TileMap
@onready var collision_shape = $CollisionShape2D
@onready var enemy_container = $EnemyContainer
@onready var collectable_container = $CollectableContainer
@onready var navigation_region = $NavigationRegion2D
@onready var detector = $Detector
const tile_fire = preload("res://objects/MapObjects/Rooms/tile_fire.tscn")
const destructible_crate = preload("res://objects/MapObjects/Destructibles/destructible_crate.tscn")
const destructible_rock = preload("res://objects/MapObjects/Destructibles/destructible_rock.tscn")

var borders = Rect2(-500, -500, 1000, 1000)
var size : Vector2 = Vector2(7, 7)
var top_left : Vector2i = Vector2i(0, 0)
var room_type : String = "normal"
var difficulty : int = 1
var explored : bool = false
var used_positions : Array[Vector2i]
var door_positions : Array[Vector2i]
	
func create_room(pos, siz, room_typ, diff):
	position = pos
	size = siz
	room_type = room_typ
	top_left = (-size/2).ceil()
	difficulty = diff
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
	if (room_type != "boss" and room_type != "first"):
		if (room_type == "loot"):
			create_loot()
		elif (randi() % 10 < 0):
			create_walled()
		elif (randi() % 10 < 0):
			create_hole()
		elif (randi() % 10 < 10):
			if (randi() % 10 < 10):
				create_crates()
			if (randi() % 10 < 10):
				create_rocks()
		if (randi() % 10 < 2):
			create_special_tiles()
	navigation_region.bake_navigation_polygon()

func create_loot():
	tile_map.set_cell(0, Vector2(0, 0), 1, Vector2(4, 2))
	var collectable = ItemDrops.weapon_list[randi() % ItemDrops.weapon_list.size()][1].instantiate()
	collectable.position = Vector2(0, 0)
	collectable_container.add_child(collectable)
	
func create_tiles(pos, size):
	var cells = []
	for y in size.y:
		for x in size.x:
			var room_cell_position = top_left + Vector2i(x, y)
			if borders.has_point(room_cell_position):
				cells.append(room_cell_position)
	tile_map.set_cells_terrain_connect(0, cells, 1, 0)

func create_special_tiles():
	for y in range(2, size.y - 2):
		for x in range(2, size.x - 2):
			var room_cell_position = top_left + Vector2i(x, y)
			if (randi() % 100 < 1):
				var new_tile = tile_fire.instantiate()
				new_tile.position = room_cell_position * 32
				collectable_container.add_child(new_tile)
				used_positions.append(room_cell_position)
				
func create_crates():
	for y in range(1 + floori(size.y/3), floori(2 * size.y / 3)):
		for x in range(1 + floori(size.x/3), floori(2 * size.x / 3)):
			var room_dest_position = top_left + Vector2i(x, y)
			if (randi() % 100 < 30):
				var new = destructible_crate.instantiate()
				new.position = room_dest_position * 32
				collectable_container.add_child(new)
				used_positions.append(room_dest_position)
				

func create_rocks():
	var rock_positions = [Vector2i(2, 2), Vector2i(2, size.y - 3), Vector2i(size.x - 3, 2), Vector2i(size.x - 3, size.y - 3),
	Vector2i(3, 2), Vector2i(3, size.y - 3), Vector2i(size.x - 4, 2), Vector2i(size.x - 4, size.y - 3),
	Vector2i(2, 3), Vector2i(2, size.y - 4), Vector2i(size.x - 3, 3), Vector2i(size.x - 3, size.y - 4),
	Vector2i(3, 3), Vector2i(3, size.y - 4), Vector2i(size.x - 4, 3), Vector2i(size.x - 4, size.y - 4),
	Vector2i(4, size.y - 3), Vector2i(2, size.y - 5), Vector2i(size.x - 3, 4), Vector2i(size.x - 5, 2), 
	Vector2i(size.x - 4, size.y - 3), Vector2i(size.x - 3, size.y - 5),
	Vector2i(2, 4), Vector2i(4, 2)
	]
	for i in rock_positions:
		var new
		if (randi() % 10 < 3):
			new = EnemySpawn.rocke_scene.instantiate()
			new.room_position = position - Vector2(floor((size.x - 2)/2), floor((size.y - 2)/2)) * 32
			new.room_size = (size - Vector2(2, 2)) * 32
		else:
			new = destructible_rock.instantiate()
			new.position = (top_left + i) * 32
			collectable_container.add_child(new)
			used_positions.append((top_left + i))



func create_walled():
	var wall_cells : Array[Vector2i] = []
	for i in range(5, size.x - 3, 5):
		for j in range(3, size.y - 5):
			wall_cells.append(Vector2i(ceili(-size.x / 2) + i, ceili(-size.y / 2) + j))
	tile_map.set_cells_terrain_connect(0, wall_cells, 1, 1)
	used_positions += wall_cells
	for i in range(5, size.x - 3, 5):
		for j in range(3, size.y - 5):
			if (randi() % 10 < 1):
				tile_map.set_cell(0, Vector2(ceili(-size.x / 2) + i, ceili(-size.y / 2) + j), 1, Vector2(1, 1))

func create_hole():
	var hole_cells : Array[Vector2i] = []
	var hole_width = 3 + randi() % (floori(size.x/2) - 1)
	var hole_height = 3 + randi() % (floori(size.y/2) - 1)
	var hole_top_left = top_left + Vector2i(2 + randi() % int(size.x - hole_width - 2), 2 + randi() % int(size.y - hole_height - 2))
	for y in range(0, hole_height - 1):
		for x in range(0, hole_width - 1):
			var hole_cell_position = hole_top_left + Vector2i(x, y)
			hole_cells.append(hole_cell_position)
	tile_map.set_cells_terrain_connect(0, hole_cells, 2, 0)
	used_positions += hole_cells

func spawn_enemies():
	var temp = int(size.x * size.y / 100) * 2
	var more = temp * randi() % (temp + 1)
	var enemy_num = 20 + more + difficulty

	var i = 0
	while i < enemy_num:
		var	spawn_pos_x = (randi() % int(size.x - 2)) - floor((size.x - 2)/2)
		var	spawn_pos_y = (randi() % int(size.y - 2)) - floor((size.y - 2)/2)
		if (!Vector2i(spawn_pos_x, spawn_pos_y) in used_positions):
			var new_enemy = EnemySpawn.select_enemy(difficulty).instantiate()
			new_enemy.position = Vector2(spawn_pos_x, spawn_pos_y) * 32 + Vector2(12, 12)
			new_enemy.room_position = position - Vector2(floor((size.x - 2)/2), floor((size.y - 2)/2)) * 32
			new_enemy.room_size = (size - Vector2(2, 2)) * 32
			enemy_container.call_deferred("add_child", new_enemy)
			used_positions.append(Vector2(spawn_pos_x, spawn_pos_y))
			i += 1
		if i > 200:
			break
				
func spawn_boss():
	var select_boss_from_list = randi() % EnemySpawn.boss_list.size()
	var new_enemy = EnemySpawn.boss_list[select_boss_from_list].instantiate()
	new_enemy.position = Vector2(0, 0) + Vector2(12, 12)
	new_enemy.room_position = position - Vector2(floor((size.x - 2)/2), floor((size.y - 2)/2)) * 32
	new_enemy.room_size = (size - Vector2(2, 2)) * 32
	enemy_container.call_deferred("add_child", new_enemy)
	
func _on_body_entered(body):
	SignalBus.emit_change_room_camera(position, size)
	if (!explored and difficulty > 0):
		if (room_type == "boss"):
			spawn_boss()
		else:
			spawn_enemies()
	explored = true


#func _on_body_exited(body):
	#explored = false
	#for i in enemy_container.get_children():
		#i.queue_free()

func room():
	pass
