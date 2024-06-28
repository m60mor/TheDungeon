extends StaticBody2D

var sound_break = preload("res://assets/Map/rock-break.mp3")
@export var hp : float = 100

func do_damage(dmg, slow_mul = 1, slow_time = 0):
	hp -= dmg
	if (hp < 0):
		var player = AudioStreamPlayer.new()
		player.stream = sound_break
		player.set_bus("sfx")
		get_tree().root.add_child(player)
		player.connect("finished", Callable(player, "queue_free"))
		player.play()
		queue_free()
		
func destructible():
	pass
