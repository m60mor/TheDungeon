extends StaticBody2D

@export var hp : float = 100

func do_damage(dmg, slow_mul = 1, slow_time = 0):
	hp -= dmg
	if (hp < 0):
		queue_free()
		
func destructible():
	pass
