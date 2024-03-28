extends CharacterBody2D

enum STATE_MOSQUITO { IDLE, CHASE}

@onready var animationTree = $AnimationTree
@onready var sprite = $Sprite2D
@onready var timer = $Timer

@export var move_speed_mosquito : float = 50

var current_state : STATE_MOSQUITO = STATE_MOSQUITO.IDLE
var move_direction : Vector2 = Vector2(0, 0)
var hp : float = 100

func _ready():
	animationTree.set("parameters/Fly/blend_position", move_direction)
	timer.start(1)

func _physics_process(_delta): 
	velocity = move_direction * move_speed_mosquito
	if (timer.time_left <= 0.0):
		timer.start(1)
	pick_new_state()
	move_and_slide()
	
func pick_new_state():
	if (current_state == STATE_MOSQUITO.IDLE):
		current_state == STATE_MOSQUITO.CHASE
				
func pick_fly_direction():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	if (move_direction.x < 0):
		sprite.flip_h = true
	elif (move_direction.x > 0):
		sprite.flip_h = false


func _on_timer_timeout():
	pick_fly_direction()

func _on_body_entered(body):
	print(body)
	hp = hp - 20
	if (hp <= 0):
		queue_free()
	body.queue_free()
	print(hp)
	
