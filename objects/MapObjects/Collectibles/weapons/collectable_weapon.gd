extends Collectable

var cooldown : float = 0

func _physics_process(_delta):
	if (cooldown > 0.01):
		cooldown -= _delta
	else:
		cooldown = 0.01

func weapon():
	pass
