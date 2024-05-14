extends Node2D

var borders = Rect2(-500, -500, 1000, 1000)

func _ready():
	generate_level()
	
	
func generate_level():
	var steps = 30
	var walker = MapGenerator.new(Vector2(100, 100), borders, steps)
	walker.queue_free()
