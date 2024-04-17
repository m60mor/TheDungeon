extends Node

signal shoot(resource : BulletBaseResource, location : Vector2, direction : Vector2, collision : int)
func emit_shoot(resource : BulletBaseResource, location : Vector2, direction : Vector2, collision : int):
	shoot.emit(resource, location, direction, collision)


signal options_close()
func emit_options_close():
	options_close.emit()
	
	
signal change_room_camera(pos)
func emit_change_room_camera(pos):
	change_room_camera.emit(pos)
