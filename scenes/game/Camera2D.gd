extends Camera2D

func _ready():
	SignalBus.connect("change_room_camera", change_room_camera)
	
func change_room_camera(pos, size):
	if (size.x <= 11):
		size = Vector2(15, 11)
	var left = floori(size.x / 2) * 32
	var right = ceili(size.x / 2) * 32
	var top = floori(size.y / 2) * 32
	var bottom = ceili(size.y / 2) * 32
	
	limit_left = pos.x - left
	limit_right = pos.x + right
	limit_top = pos.y - top
	limit_bottom = pos.y + bottom
	global_position = pos
