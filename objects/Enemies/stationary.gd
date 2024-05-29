extends CharacterBody2D
class_name Stationary

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_timer = $AnimationTimer
@onready var hitbox = $Hitbox

@export var hp : float = 40

var room_position = null
var room_size = null
var player_chase = false
var player : CharacterBody2D = null

func _ready():
	animation_timer.start(1)

func _physics_process(_delta):
	velocity = Vector2.ZERO
	move_and_slide()

func pick_idle_target():
	pass

func _on_animation_timer_timeout():
	pass

func _on_player_detection_body_entered(body):
	pass
	
func _on_player_detection_body_exited(body):
	if (body.has_method("player")):
		animation_timer.start(1)
		player_chase = false

func do_damage(dmg, slow_mul = 1, slow_time = 0):
	hp = hp - dmg
	if (hp <= 0):
		var select_drop : Array = ItemDrops.drop_collectable()
		if (select_drop.size() > 0):
			for collectable in select_drop:
				var new = collectable.instantiate()
				new.position = global_position - Vector2(16, 16)
				NodeExtensions.get_collectable_container().add_child(new)
		queue_free()
		
#func random_drops():

func enemy():
	pass
