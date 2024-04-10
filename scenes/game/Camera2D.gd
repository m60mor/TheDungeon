extends Camera2D

func _ready():
	SignalBus.connect("change_room_camera", change_room_camera)
	
func change_room_camera(pos):
	global_position = pos
