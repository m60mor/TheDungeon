extends Enemy

@export var bullet_resource : BulletBaseResource = null
@onready var attack_timer = $AttackTimer

var can_fire = true

func _physics_process(_delta):
	if (player_chase && can_fire == true):
		attack_timer.start(1)
		can_fire = false
	super(_delta)

func _on_attack_timer_timeout():
	SignalBus.emit_shoot(bullet_resource, global_position, (player.global_position - global_position).normalized(), 4)
	can_fire = true
