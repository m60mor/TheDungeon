extends Enemy

@onready var attack_timer = $AttackTimer

func pick_direction():
	if (player_chase == true):
		var direction = player.global_position - global_position 
		move_direction = Vector2(player.global_position - global_position).normalized()
		if (abs(direction.x) + abs(direction.y) < 40):
			move_direction.x = 0
			move_direction.y = 0
		move_speed_multiplier = 1.5
	else:
		move_speed_multiplier = 1
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	super()

func _on_attack_detection_body_entered(body):
	if (body.has_method("player")):
		attack_timer.start(1)

func _on_attack_detection_body_exited(body):
	if (body.has_method("player")):
		attack_timer.stop()
		
func _on_attack_timer_timeout():
	player.do_damage(damage)
