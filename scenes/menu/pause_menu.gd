extends Control

@onready var main_menu = "res://scenes/menu/main_menu.tscn"
@onready var label = $Panel/VBoxContainer/Label
@onready var resume_button = $Panel/VBoxContainer/VBoxContainer/ResumeButton

func _init():
	SignalBus.connect("death_screen", death_screen)

func death_screen():
	label.text = "Game Over"
	resume_button.visible = false

func _on_resume_button_pressed():
	get_tree().paused = false
	self.visible = false

func _on_exit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu)
