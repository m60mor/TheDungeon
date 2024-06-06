extends Control

@onready var main_menu = "res://menu/main_menu.tscn"
@onready var label = $Panel/VBoxContainer/Label
@onready var resume_button = $Panel/VBoxContainer/VBoxContainer/ResumeButton
@onready var separator2 = $Panel/VBoxContainer/Separator2

func _init():
	SignalBus.connect("death_screen", death_screen)
	SignalBus.connect("win_screen", win_screen)

func death_screen():
	label.text = "Game Over"
	separator2.custom_minimum_size = Vector2(0, 60)
	resume_button.visible = false
	
func win_screen():
	label.text = "You won"
	separator2.custom_minimum_size = Vector2(0, 60)
	resume_button.visible = false

func _on_resume_button_pressed():
	get_tree().paused = false
	self.visible = false

func _on_exit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu)
	SignalBus.reset_inventory.emit()
