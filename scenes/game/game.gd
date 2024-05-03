extends Node

@onready var pause_menu = $CanvasLayer/PauseMenu
var alive : bool = true

func _init():
	SignalBus.connect("death_screen", death_screen)

func _input(event):
	if (event.is_action_pressed("pause") && alive == true):
		toggle_pause_menu()
		
func death_screen():
	toggle_pause_menu()
	alive = false
		
func toggle_pause_menu():
	var is_paused : bool = get_tree().paused
	get_tree().paused = !is_paused
	pause_menu.visible = !is_paused
