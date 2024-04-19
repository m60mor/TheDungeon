class_name Player
extends CharacterBody2D

@onready var timer = $Timer

@export var fire_rate: float = 0.5
@export var player_speed : float = 600
@export var bullet_resource : BulletBaseResource = null

var can_fire : bool = true	
var hp : float = 100
var can_teleport = true

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if (Input.is_action_pressed("shoot") && can_fire == true):
		print((position/32).floor().snapped(Vector2(1, 1)))
		can_fire = false
		timer.start(fire_rate)
		SignalBus.emit_shoot(bullet_resource, position, (get_global_mouse_position() - global_position).normalized(), 3)
		print(player_speed)
	velocity = input_direction * player_speed
	move_and_slide()

#func _process(_delta):
	#self.look_at(get_global_mouse_position())

func _on_timer_timeout():
	can_fire = true
	timer.stop()
	
func do_damage(dmg):
	hp = hp - dmg
	print(hp)
	if (hp <= 0):
		queue_free()
	
func player():
	pass
