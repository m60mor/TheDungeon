extends Enemy

func pick_idle_target():
	nav.target_position = global_position + Vector2(randi_range(1, 1), randi_range(-1, 1)).normalized() * 64
	super()

func pick_direction():
	if (player_chase == true):
		selected_direction = Vector2(player.global_position - global_position).normalized().rotated(1.1 * PI/2)
	else:
		selected_direction = (nav.get_next_path_position() - global_position).normalized()
	super()	
	
func do_damage(dmg, slow_mul = 1, slow_time = 0):
	ItemDrops.collectables_list = [[100, ItemDrops.pid0]]
	super(dmg, slow_mul, slow_time)
