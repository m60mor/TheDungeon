extends Area2D
class_name RoomTeleport

@onready var sprite = $Sprite2D
@onready var timer = $Timer

var spawn_position : Vector2 = Vector2.ZERO
var teleport_to : Vector2 = Vector2.ZERO
var player = null
var saved_speed : int = 0
	
func set_teleport_positions(pos, teleport_pos, direction):
	spawn_position = pos
	position = spawn_position 
	teleport_to = teleport_pos + Vector2(32, 32) * direction
	self.rotate(direction.angle())

func _on_body_entered(body):
	if (body.has_method("player")):
		if (body.can_teleport == true):
			player = body
			var areas = self.get_overlapping_areas()
			for i in areas:
				if (i.has_method("room")):
					if (i.get_node("EnemyContainer").get_child_count() < 1):
						body.can_teleport = false
						body.position = teleport_to
						saved_speed = body.player_speed 
						body.player_speed = 0
						timer.start(0.3)

func _on_timer_timeout():
	player.player_speed = saved_speed
	player.can_teleport = true
