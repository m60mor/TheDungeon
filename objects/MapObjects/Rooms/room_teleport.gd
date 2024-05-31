extends Area2D
class_name RoomTeleport

@onready var sprite = $Sprite2D
@onready var timer = $Timer

var spawn_position : Vector2 = Vector2.ZERO
var teleport_to : Vector2 = Vector2.ZERO
var room = null
var player = null
var saved_speed : int = 0

func _ready():
	if (self.get_rotation_degrees() == 90):
		sprite.scale.x = 0.5

func set_teleport_positions(pos, teleport_pos, direction, rom):
	room = rom
	spawn_position = pos
	if (direction.y > 0):
		spawn_position -= Vector2(0, 8)
	position = spawn_position 
	teleport_to = teleport_pos + Vector2(32, 32) * direction
	self.rotate(direction.angle())

func _on_body_entered(body):
	#player
	if (body.can_teleport == true):
		player = body
		if (room.get_node("EnemyContainer").get_child_count() < 1):
			body.can_teleport = false
			body.position = teleport_to
			saved_speed = body.player_speed 
			body.player_speed = 0
			timer.start(0.3)

func _on_timer_timeout():
	player.player_speed = saved_speed
	player.can_teleport = true
