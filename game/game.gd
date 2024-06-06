extends Node

@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var win_timer = $WinTimer
@onready var countdown_label = $CanvasLayer/CountdownLabel
var alive : bool = true

func _init():
	SignalBus.connect("death_screen", death_screen)
	SignalBus.connect("win_screen", win_screen)

func _process(delta):
	countdown_label.text = "You won, you will be transported to menu in " + str(ceil(win_timer.time_left)) + " seconds!"

func _input(event):
	if (event.is_action_pressed("pause") && alive == true):
		toggle_pause_menu()
		
func death_screen():
	toggle_pause_menu()
	alive = false
	
func win_screen():
	win_timer.start(10)
	countdown_label.visible = true

func _on_win_timer_timeout():
	toggle_pause_menu()
	alive = false
	countdown_label.visible = false
		
func toggle_pause_menu():
	if (countdown_label.visible):
		win_timer.stop()
		win_timer.start(0.01)
	else:
		var is_paused : bool = get_tree().paused
		get_tree().paused = !is_paused
		pause_menu.visible = !is_paused
