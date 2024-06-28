extends Enemy

@onready var idle_timer = $IdleTimer

func _ready():
	idle_timer.start(1)
	super()

func pick_idle_target():
	var select_max_x = room_position.x + room_size.x - 16
	var select_max_y = room_position.y + room_size.y - 16
	nav.target_position = Vector2(randi_range(room_position.x + 16, select_max_x - 16), randi_range(room_position.y + 16, select_max_y - 16))

func pick_direction():
	if (player_chase == true and is_instance_valid(player)):
		selected_direction = Vector2(player.global_position - global_position).normalized().rotated(1.1 * PI/2)
	else:
		selected_direction = (nav.get_next_path_position() - global_position).normalized()
	super()	
	
func do_damage(dmg, slow_mul = 1, slow_time = 0):
	ItemDrops.collectables_list = [[100, ItemDrops.pid0], [100, ItemDrops.wid1]]
	super(dmg, slow_mul, slow_time)

func _on_idle_timer_timeout():
	pick_idle_target()
	idle_timer.start(1)
