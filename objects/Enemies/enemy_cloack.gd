extends Enemy

@export var bullet_resource : BulletBaseResource = null
@onready var attack_timer = $AttackTimer

var can_fire = true

func _physics_process(_delta):
	if (player_chase && can_fire == true):
		attack_timer.start(1)
		can_fire = false
	super(_delta)
	
func pick_direction():
	if (player_chase == true):
		move_direction = Vector2(player.global_position - global_position).normalized().rotated(1.1 * PI/2)
	else:
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	super()

func _on_attack_timer_timeout():
	SignalBus.emit_shoot(bullet_resource, global_position, (player.global_position - global_position).normalized(), 4)
	can_fire = true

func do_damage(dmg, slow_mul = 1, slow_time = 0):
	ItemDrops.collectables_list = [[100, ItemDrops.wid1]]
	super(dmg, slow_mul, slow_time)
