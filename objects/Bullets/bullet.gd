class_name Bullet
extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var visibilityNotifier = $VisibleOnScreenNotifier2D
@onready var timer = $Timer

var direction : Vector2 = Vector2.RIGHT
var speed : float = 0
var damage : float = 20

func _physics_process(delta):
	bullet_move(delta)
	
func bullet_move(delta : float):
	move_and_collide(speed * direction * delta)

func _on_screen_exited():
	timer.start(1)

func _on_timer_timeout():
	queue_free()
	

