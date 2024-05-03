extends TextureProgressBar

func _init():
	SignalBus.connect("health_bar_damage", update)

func _ready():
	value = 100

func update(dmg):
	value = value - dmg
