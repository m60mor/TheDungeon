extends Node

@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var pause_timer = $PauseTimer
@onready var countdown_label = $CanvasLayer/CountdownLabel
@onready var healt_bar = $CanvasLayer/HealtBar
@onready var hotbar = $CanvasLayer/Hotbar
var alive : bool = true
var countdown_text = ''


func _init():
	SignalBus.connect("death_screen", death_screen)
	SignalBus.connect("win_screen", win_screen)
	SignalBus.connect("resume", resume)

func _process(delta):
	countdown_label.text = countdown_text + str(ceil(pause_timer.time_left)) + " seconds!"

func _input(event):
	if (event.is_action_pressed("pause") && alive == true):
		toggle_pause_menu()
		
func death_screen():
	pause_timer.start(3)
	countdown_text = "Game over, you will be transported to menu in "
	countdown_label.visible = true
	
func win_screen():
	pause_timer.start(10)
	countdown_text = "You won, you will be transported to menu in "
	countdown_label.visible = true

func _on_pause_timer_timeout():
	toggle_pause_menu()
	alive = false
	countdown_label.visible = false
	
func toggle_pause_menu():
	if (countdown_label.visible):
		pause_timer.stop()
		pause_timer.start(0.01)
	else:
		var is_paused : bool = get_tree().paused
		get_tree().paused = !is_paused
		pause_menu.visible = !is_paused
		healt_bar.visible = is_paused
		hotbar.visible = is_paused
		
func resume():
	healt_bar.visible = true
	hotbar.visible = true
