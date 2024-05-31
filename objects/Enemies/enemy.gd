extends CharacterBody2D
class_name Enemy

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_timer = $AnimationTimer
@onready var slow_timer = $SlowTimer
@onready var hitbox = $Hitbox
@onready var rc_left = $RayCasts/RayCastLeft
@onready var rc_right = $RayCasts/RayCastRight
@onready var rc_up = $RayCasts/RayCastUp
@onready var rc_down = $RayCasts/RayCastDown
@onready var rc_lu = $RayCasts/RayCastLU
@onready var rc_ld = $RayCasts/RayCastLD
@onready var rc_ru = $RayCasts/RayCastRU
@onready var rc_rd = $RayCasts/RayCastRD
@onready var nav : NavigationAgent2D = $NavigationAgent2D

@export var move_speed : float = 80
@export var move_speed_multiplier : float = 1.0
@export var hp : float = 40

var room_position = null
var room_size = null
var player_chase = false
var player : CharacterBody2D = null
var selected_direction : Vector2 = Vector2(0, 0)
var move_direction : Vector2 = Vector2(0, 0)
var ray_cast_moves = [Vector2(0, -1), Vector2(1, -1), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1)]
var desirable_moves = []
var rc_list = []
var danger_moves = []
var possible_moves = []

func _ready():
	pick_idle_target()
	rc_list = [rc_up, rc_ru, rc_right, rc_rd, rc_down, rc_ld, rc_left, rc_lu]

func _physics_process(_delta):
	pick_direction()
	velocity = velocity.lerp(move_direction * move_speed * move_speed_multiplier, 1 * _delta)
	move_and_slide()

func pick_idle_target():
	pass
			
func pick_direction():
	desirable_moves = []
	danger_moves = [0, 0, 0, 0, 0, 0, 0, 0]
	for i in ray_cast_moves:
		desirable_moves.push_back(selected_direction.dot(i))
	for i in range(rc_list.size()):
		if (rc_list[i].is_colliding()):
			danger_moves[i] = 10
			danger_moves[i - 1] = 5
			danger_moves[(i + 1) % 8] = 5
	for i in range(rc_list.size()):
		desirable_moves[i] = desirable_moves[i] - danger_moves[i]
	
	var desirable_move = desirable_moves.max()
	var best_move_index = desirable_moves.find(desirable_move, 0)
	move_direction = ray_cast_moves[best_move_index]
	#if (absf(desirable_move) > 1.05):
		#if (move_direction.x < 0):
			#animated_sprite.flip_h = true
		#elif (move_direction.x > 0):
			#animated_sprite.flip_h = false
			
	if (move_direction !=Vector2.ZERO):
		if (absf(desirable_move) > 1.05):
			if (move_direction.x > 0):
				animated_sprite.play("move")
				animated_sprite.flip_h = false
			elif (move_direction.x < 0):
				animated_sprite.play("move")
				animated_sprite.flip_h = true
	else:
		animated_sprite.play("idle")

func _on_animation_timer_timeout():
	player_chase = false

func _on_player_detection_body_entered(body):
	player_chase = true
	player = body
	
func _on_player_detection_body_exited(body):
		animation_timer.start(1)

func _on_navigation_agent_2d_target_reached():
	if (player_chase == false):
		pick_idle_target()
	
func _on_navigation_agent_2d_navigation_finished():
	if (player_chase == false):
		pick_idle_target()



func do_damage(dmg, slow_mul = 1, slow_time = 0):
	hp = hp - dmg
	move_speed_multiplier = slow_mul
	slow_timer.start(slow_time)
	if (hp <= 0):
		var select_drop : Array = ItemDrops.drop_collectable()
		if (select_drop.size() > 0):
			for collectable in select_drop:
				var new = collectable.instantiate()
				new.position = global_position - Vector2(16, 16)
				NodeExtensions.get_collectable_container().add_child(new)
		queue_free()
		
#func random_drops():
			#

func _on_slow_timer_timeout():
	move_speed_multiplier = 1

func enemy():
	pass
