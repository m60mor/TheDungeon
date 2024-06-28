extends Enemy

@onready var attack_timer = $AttackTimer
@export var damage : float = 10

func pick_idle_target():
	var select_max_x = room_position.x + room_size.x - 16
	var select_max_y = room_position.y + room_size.y - 16
	nav.target_position = Vector2(randi_range(room_position.x + 16, select_max_x - 16), randi_range(room_position.y + 16, select_max_y - 16))
	super()

func pick_direction():
	if (player_chase and is_instance_valid(player)):
		nav.target_position = player.global_position
		selected_direction = (nav.get_next_path_position() - global_position).normalized()
	else:
		selected_direction = (nav.get_next_path_position() - global_position).normalized()
	super()

func _on_player_detection_body_entered(body):
	super(body)
	move_speed_multiplier = 1.5
	
func _on_player_detection_body_exited(body):
	super(body)
	move_speed_multiplier = 1

func _on_attack_detection_body_entered(body):
	if (body.has_method("player")):
		attack_timer.start(0.3)

func _on_attack_detection_body_exited(body):
	if (body.has_method("player")):
		attack_timer.stop()
		
func _on_attack_timer_timeout():
	if (is_instance_valid(player)):
		player.do_damage(damage)
		attack_timer.start(1)
	
func do_damage(dmg, slow_mul = 1, slow_time = 0):
	ItemDrops.collectables_list = []
	super(dmg, slow_mul, slow_time)
