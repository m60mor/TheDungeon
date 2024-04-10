extends Area2D
class_name Room

@onready var collision_shape = $CollisionShape2D
	
func create_room(pos, size):
	position = pos
	collision_shape = await $CollisionShape2D
	
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = size * 16
	collision_shape.shape = rect_shape
	

func _on_body_entered(body):
	if (body.has_method("player")):
		SignalBus.emit_change_room_camera(position)
