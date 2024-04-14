extends CharacterBody2D
class_name EnemyFly

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_timer = $AnimationTimer
#@onready var attack_timer = $AttackTimer


@export var move_speed_fly : float = 200

var player_chase = false
var player : CharacterBody2D = null
var move_direction : Vector2 = Vector2(0, 0)

var damage : float = 10
var hp : float = 100

func _ready():
	animation_timer.start(1)

func _physics_process(_delta):
	velocity = move_direction * move_speed_fly
	if (animation_timer.time_left <= 0.0):
		animation_timer.start(1)
	move_and_slide()
				
func pick_fly_direction():
	if (player_chase == true):
		move_direction = Vector2(player.position - self.position).normalized().rotated(1.1 * PI/2)
	else:
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
		
	if (move_direction.x < 0):
		animated_sprite.flip_h = true
	elif (move_direction.x > 0):
		animated_sprite.flip_h = false


func _on_animation_timer_timeout():
	pick_fly_direction()

func _on_player_detection_body_entered(body):
	animation_timer.stop()
	animation_timer.start(0.1)
	player_chase = true
	player = body
	animated_sprite.speed_scale = 1.3
	
func _on_player_detection_body_exited(body):
	if (body.has_method("player")):
		animation_timer.stop()
		animation_timer.start(1)
		animated_sprite.speed_scale = 1.0
		player_chase = false

func _on_bullet_detection_body_entered(body):
	#player_chase = true
	hp = hp - 50
	if (hp <= 0):
		queue_free()
	body.queue_free()


func _on_attack_detection_body_entered(body):
	if (body.has_method("player")):
		player.do_damage(damage)
		#attack_timer.start(1)

func _on_attack_detection_body_exited(body):
	if (body.has_method("player")):
		#attack_timer.stop()
		pass
		
func _on_attack_timer_timeout():
	player.do_damage(damage)


func enemy():
	pass
