extends Area2D
class_name Room

var mosquito_scene : PackedScene = preload("res://objects/Enemies/enemy_mosquito.tscn")
var fly_scene : PackedScene = preload("res://objects/Enemies/enemy_fly.tscn")

@onready var collision_shape = $CollisionShape2D
@onready var enemy_container = $EnemyContainer
@onready var tile_map = $TileMap

var borders = Rect2(-500, -500, 1000, 1000)
var size : int = 7;
	
func create_room(pos, size):
	position = pos
	collision_shape = $CollisionShape2D
	enemy_container = $EnemyContainer
	tile_map = $TileMap
	
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = size * 16
	collision_shape.shape = rect_shape
	create_tiles(pos, size)
	
func create_tiles(pos, size):
	var top_left = (- size/2).ceil()
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

func spawn_enemies():
	var new_fly = fly_scene.instantiate() as EnemyFly
	new_fly.position = -Vector2(floori(size * 16 / 2), floori(size * 16 / 2))
	enemy_container.add_child(new_fly)
	
func _on_body_entered(body):
	if (body.has_method("player")):
		SignalBus.emit_change_room_camera(position)
		spawn_enemies()


func _on_body_exited(body):
	print(body)
	pass # Replace with function body.
