extends TextureProgressBar

func _init():
	SignalBus.connect("health_bar_set", update)

func _ready():
	value = 100

func update(health):
	value = health
