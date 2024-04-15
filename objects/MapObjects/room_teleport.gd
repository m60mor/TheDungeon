extends Area2D
class_name RoomTeleport

@onready var sprite = $Sprite2D


var spawn_position : Vector2 = Vector2.ZERO
var teleport_to : Vector2 = Vector2.ZERO
	
func set_teleport_positions(pos, teleport_pos, direction):
	spawn_position = pos + Vector2(16, 16)
	position = spawn_position 
	teleport_to = teleport_pos
	self.rotate(direction.angle())

func _on_body_entered(body):
	if (body.has_method("player") and body.can_teleport == true):
		body.position = teleport_to
		body.can_teleport = false

func _on_body_exited(body):
	if (body.has_method("player")):
		body.can_teleport = true
