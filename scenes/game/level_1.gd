extends Node2D

var borders = Rect2(-500, -500, 1000, 1000)

@onready var tile_map = $TileMap
@onready var room_detector : Area2D = $RoomDetector

func _ready():
	generate_level()
	
	
func generate_level():
	var steps = 20
	var walker = MapGenerator.new(Vector2(100, 100), borders, tile_map, steps)
	walker.queue_free()
