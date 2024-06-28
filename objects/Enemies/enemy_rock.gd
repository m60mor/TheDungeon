extends Enemy

@onready var attack_timer = $AttackTimer
@export var damage : float = 10

func _physics_process(_delta):
	danger_moves = [0, 0, 0, 0, 0, 0, 0, 0]
	pick_direction()
	if (player_chase):
		velocity = velocity.lerp(move_direction * move_speed * move_speed_multiplier, 1 * _delta)
		move_and_slide()

func pick_direction():
	move_speed_multiplier = 1
	if (player_chase and is_instance_valid(player)):
		nav.target_position = player.global_position
		selected_direction = (nav.get_next_path_position() - global_position).normalized()
	else:
		selected_direction = (nav.get_next_path_position() - global_position).normalized()
		
	desirable_moves = []
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
			
	if (player_chase):
		animated_sprite.play("move")
		if (absf(desirable_move) > 1.05):
			if (move_direction.x > 0):
				animated_sprite.flip_h = false
			elif (move_direction.x < 0):
				animated_sprite.flip_h = true
	else:
		animated_sprite.play("idle")


func _on_player_detection_body_entered(body):
	super(body)
	
func _on_player_detection_body_exited(body):
	animation_timer.start(3)

func _on_navigation_agent_2d_target_reached():
	pass
	
func _on_navigation_agent_2d_navigation_finished():
	pass

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
