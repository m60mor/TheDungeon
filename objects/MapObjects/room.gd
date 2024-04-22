extends Area2D
class_name Room

var mosquito_scene : PackedScene = preload("res://objects/Enemies/enemy_mosquito.tscn")
var fly_scene : PackedScene = preload("res://objects/Enemies/enemy_fly.tscn")
var cloack_scene : PackedScene = preload("res://objects/Enemies/enemy_cloack.tscn")
var enemy_list = [mosquito_scene, fly_scene, cloack_scene]

@onready var collision_shape = $CollisionShape2D
@onready var enemy_container = $EnemyContainer
@onready var tile_map = $TileMap

var borders = Rect2(-500, -500, 1000, 1000)
var size : Vector2 = Vector2(7, 7);
var room_type : String = "normal"
var explored : bool = false
	
func create_room(pos, siz, room_typ):
	position = pos
	size = siz
	room_type = room_typ
	collision_shape = $CollisionShape2D
	enemy_container = $EnemyContainer
	tile_map = $TileMap
	
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = size * 16
	collision_shape.shape = rect_shape
	
	create_tiles(position, size)
	if (room_type == "loot"):
		tile_map.set_cell(0, Vector2(0, 0), 1, Vector2(4, 2))
	else:
		if (randi() % 10 < 3):
			create_hole((- size/2).ceil(), size)
	
func create_tiles(pos, size):
	var top_left = (- size/2).ceil()
	var cells = []
	for y in size.y:
		for x in size.x:
			var room_cell_position = top_left + Vector2(x, y)
			if borders.has_point(room_cell_position):
				cells.append(room_cell_position)
	tile_map.set_cells_terrain_connect(0, cells, 1, 0)

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

func spawn_enemies():
	if (room_type == "normal"):
		var temp = int(size.x * size.y / 100) * 2
		var more = temp * randi() % (temp + 1)
		var enemy_num = 1 + more
		
		var spawn_positions = []
		for i in range(enemy_num):
			var spawn_pos_x = (randi() % int(size.x - 2)) - floor((size.x - 2)/2)
			var spawn_pos_y = (randi() % int(size.y - 2)) - floor((size.y - 2)/2)
			if (!spawn_positions.has(Vector2(spawn_pos_x, spawn_pos_y))):
				var select_enemy_from_list = randi() % enemy_list.size()
				var new_enemy = enemy_list[select_enemy_from_list].instantiate()
				new_enemy.position = Vector2(spawn_pos_x, spawn_pos_y) * 32 + Vector2(16, 16)
				enemy_container.add_child(new_enemy)
				spawn_positions.append(Vector2(spawn_pos_x, spawn_pos_y))
			else:
				i -= 1
	
func _on_body_entered(body):
	if (!explored):
		if (body.has_method("player")):
			SignalBus.emit_change_room_camera(position)
			spawn_enemies()
			explored = true


func _on_body_exited(body):
	#print(body)
	pass # Replace with function body.
