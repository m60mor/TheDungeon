extends Stationary

@export var bullet_resource : BulletBaseResource = null
@onready var attack_timer = $AttackTimer

var go_to : Vector2 = Vector2(0, 0)
var can_fire : bool = false

func _physics_process(_delta):
	if (player_chase && can_fire):
		attack_timer.start(1)
		can_fire = false
	super(_delta)

func _on_attack_timer_timeout():
	SignalBus.emit_shoot(bullet_resource, global_position, Vector2(0, 1), 4)
	SignalBus.emit_shoot(bullet_resource, global_position, Vector2(0, -1), 4)
	SignalBus.emit_shoot(bullet_resource, global_position, Vector2(1, 0), 4)
	SignalBus.emit_shoot(bullet_resource, global_position, Vector2(-1, 0), 4)
	SignalBus.emit_shoot(bullet_resource, global_position, Vector2(0.5, 0.5), 4)
	SignalBus.emit_shoot(bullet_resource, global_position, Vector2(-0.5, 0.5), 4)
	SignalBus.emit_shoot(bullet_resource, global_position, Vector2(0.5, -0.5), 4)
	SignalBus.emit_shoot(bullet_resource, global_position, Vector2(-0.5, -0.5), 4)
	can_fire = true
	
func _on_player_detection_body_entered(body):
	player_chase = true
	player = body
	attack_timer.start(0.3)
	super(body)

func do_damage(dmg, slow_mul = 1, slow_time = 0):
	ItemDrops.collectables_list = [[100, ItemDrops.wid1]]
	super(dmg, slow_mul, slow_time)
