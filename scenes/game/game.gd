extends Node

@onready var pause_menu = $CanvasLayer/PauseMenu

func _input(event):
	if (event.is_action_pressed("pause")):
		var is_paused : bool = get_tree().paused
		get_tree().paused = !is_paused
		pause_menu.visible = !is_paused
		
