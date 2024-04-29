extends CharacterBody2D
class_name Enemy

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_timer = $AnimationTimer
@onready var slow_timer = $SlowTimer
@export var move_speed : float = 80
@export var move_speed_multiplier : float = 1.0
@export var damage : float = 10
@export var hp : float = 40

var player_chase = false
var player : CharacterBody2D = null
var move_direction : Vector2 = Vector2(0, 0)


func _ready():
	animation_timer.start(1)

func _physics_process(_delta):
	velocity = move_direction * move_speed * move_speed_multiplier
	if (animation_timer.time_left <= 0.0):
		animation_timer.start(1)
	move_and_slide()
				
func pick_direction():
	if (move_direction.x < 0):
		animated_sprite.flip_h = true
	elif (move_direction.x > 0):
		animated_sprite.flip_h = false


func _on_animation_timer_timeout():
	pick_direction()

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

func do_damage(dmg, slow_mul, slow_time):
	hp = hp - dmg
	move_speed_multiplier = slow_mul
	slow_timer.start(slow_time)
	if (hp <= 0):
		queue_free()
		
func _on_slow_timer_timeout():
	move_speed_multiplier = 1

func enemy():
	pass
