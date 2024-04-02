extends Node2D

var borders = Rect2(-100, -100, 200, 200)

@onready var tile_map = $TileMap

func _ready():
	generate_level()
	
	
func generate_level():
	var walker = MapGenerator.new(Vector2(100, 100), borders, tile_map)
	var map = walker.walk(20)
	walker.queue_free()
	#tile_map.update_bitmask_region(borders.position, borders.end)
