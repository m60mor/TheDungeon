class_name Bullet
extends Area2D

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var visibilityNotifier = $VisibleOnScreenNotifier2D
@onready var timer = $Timer

var direction : Vector2 = Vector2.RIGHT
var speed : float = 0
var damage : float = 0
var slow_multiplier : float = 1
var slow_time : float = 0

func _ready():
	pass

func _physics_process(delta):
	bullet_move(delta)
	
func bullet_move(delta : float):
	position += speed * direction * delta * 2
	#move_and_collide(speed * direction * delta)

func _on_screen_exited():
	timer.start(5)

func _on_timer_timeout():
	queue_free()
	
func bullet():
	pass

func _on_body_entered(body):
	pass

func _on_area_exited(area):
	if (area.has_method("room")):
		queue_free()
