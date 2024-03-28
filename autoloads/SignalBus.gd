extends Node

signal shoot(resource : BulletBaseResource, location : Vector2, direction : Vector2)

func emit_shoot(resource : BulletBaseResource, location : Vector2, direction : Vector2):
	shoot.emit(resource, location, direction)


signal options_close()

func emit_options_close():
	options_close.emit()
