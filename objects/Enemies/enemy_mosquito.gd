extends CharacterBody2D

enum STATE_MOSQUITO { IDLE, CHASE}

#@onready var animationTree = $AnimationTree
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_timer = $AnimationTimer
@onready var attack_timer = $AttackTimer


@export var move_speed_mosquito : float = 100

var player_chase = false
var player : CharacterBody2D = null
var current_state : STATE_MOSQUITO = STATE_MOSQUITO.IDLE
var move_direction : Vector2 = Vector2(0, 0)

var damage : float = 10
var hp : float = 100

func _ready():
	#animationTree.set("parameters/Fly/blend_position", move_direction)
	animation_timer.start(1)

func _physics_process(_delta):
	velocity = move_direction * move_speed_mosquito
	if (animation_timer.time_left <= 0.0):
		animation_timer.start(1)
	#pick_new_state()
	move_and_slide()
	
#func pick_new_state():
	#if (current_state == STATE_MOSQUITO.IDLE):
		#current_state == STATE_MOSQUITO.CHASE
				
func pick_fly_direction():
	if (player_chase == true):
		move_direction = Vector2(player.position - self.position).normalized()
		move_speed_mosquito = 2 * move_speed_mosquito
	else:
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
		
	if (move_direction.x < 0):
		animated_sprite.flip_h = true
	elif (move_direction.x > 0):
		animated_sprite.flip_h = false


func _on_animation_timer_timeout():
	move_speed_mosquito = 100
	pick_fly_direction()

func _on_player_detection_body_entered(body):
	animation_timer.stop()
	animation_timer.start(0.1)
	player_chase = true
	player = body
	animated_sprite.speed_scale = 2.0
	
func _on_player_detection_body_exited(body):
	animation_timer.stop()
	animation_timer.start(1)
	animated_sprite.speed_scale = 1.0
	player_chase = false

func _on_bullet_detection_body_entered(body):
	print("A")
	player_chase = true
	hp = hp - 20
	if (hp <= 0):
		queue_free()


func _on_attack_detection_body_entered(body):
	if (body.has_method("player")):
		player.do_damage(damage)
		attack_timer.start(1)

func _on_attack_detection_body_exited(body):
	if (body.has_method("player")):
		attack_timer.stop()
		
func _on_attack_timer_timeout():
	player.do_damage(damage)


func enemy():
	pass
