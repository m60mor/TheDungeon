extends Enemy

func pick_direction():
	if (player_chase == true):
		move_direction = Vector2(player.global_position - global_position).normalized().rotated(1.1 * PI/2)
	else:
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	super()
