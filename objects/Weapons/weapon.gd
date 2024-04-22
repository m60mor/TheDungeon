extends AnimatedSprite2D
class_name Weapon

@onready var fire_rate_timer : Timer = $FireRateTimer as Timer
@export var bullet_resource : BulletBaseResource = null
@export var can_fire : bool = true
@export var fire_rate : float = 0.5

func _init():
	print("init")
	fire_rate_timer = $FireRateTimer

func _ready():
	fire_rate_timer = $FireRateTimer
	print(fire_rate_timer)
	print("A")

func shoot(pos, dir):
	if (can_fire):
		can_fire = false
		fire_rate_timer.start(fire_rate)
		SignalBus.emit_shoot(bullet_resource, pos, dir, 3)

func _on_fire_rate_timer_timeout():
	can_fire = true
