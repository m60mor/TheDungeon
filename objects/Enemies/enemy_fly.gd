extends Enemy

func pick_direction():
	if (player_chase == true):
		move_direction = Vector2(player.global_position - global_position).normalized().rotated(1.1 * PI/2)
	else:
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	super()
	
func do_damage(dmg, slow_mul = 1, slow_time = 0):
	ItemDrops.collectables_list = [[100, ItemDrops.pid0]]
	super(dmg, slow_mul, slow_time)
