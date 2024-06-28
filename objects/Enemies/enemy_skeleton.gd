extends Enemy

@export var bullet_resource : BulletBaseResource = null
@onready var attack_timer = $AttackTimer

var go_to : Vector2 = Vector2(0, 0)
var can_fire : bool = true

func _physics_process(_delta):
	if (player_chase && can_fire == true):
		attack_timer.start(fire_rate)
		fire_rate = 1
		can_fire = false
	super(_delta)
	
func pick_idle_target():
	var select_max_x = room_position.x + room_size.x - 16
	var select_max_y = room_position.y + room_size.y - 16
	nav.target_position = Vector2(randi_range(room_position.x + 16, select_max_x - 16), randi_range(room_position.y + 16, select_max_y - 16))
	super()

func pick_direction():
	if (player_chase and is_instance_valid(player)):
		nav.target_position = player.global_position
		selected_direction = (nav.get_next_path_position() - global_position).normalized()
		if (global_position.distance_to(player.global_position) < 200):
			danger_moves[ray_cast_moves.find(round(selected_direction))] = 2
			danger_moves[ray_cast_moves.find(round(selected_direction)) - 1] = 2
			danger_moves[(ray_cast_moves.find(round(selected_direction)) + 1) % 8] = 2
			danger_moves[(ray_cast_moves.find(round(selected_direction)) + 4) % 8] = -2
	else:
		selected_direction = (nav.get_next_path_position() - global_position).normalized()
	super()

func _on_attack_timer_timeout():
	if (is_instance_valid(player)):
		SignalBus.emit_shoot(bullet_resource, global_position, (player.global_position - global_position).normalized(), 4)
	can_fire = true

func do_damage(dmg, slow_mul = 1, slow_time = 0):
	ItemDrops.collectables_list = [[10, ItemDrops.pid0], [5, ItemDrops.wid3]]
	super(dmg, slow_mul, slow_time)
