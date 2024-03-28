extends Node2D

var borders = Rect2(-1, -1, 38, 21)

@onready var tile_map = $TileMap

func _ready():
	generate_level()
	
	
func generate_level():
	var walker = MapGenerator.new(Vector2(19, 11), borders)
	var map = walker.walk(500)
	walker.queue_free()
	for location in map:
		tile_map.set_cell(0, location, -1)
	#tile_map.update_bitmask_region(borders.position, borders.end)
