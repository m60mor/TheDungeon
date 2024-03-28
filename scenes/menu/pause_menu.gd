extends Control

@onready var main_menu = "res://scenes/menu/main_menu.tscn"

func _on_resume_button_pressed():
	get_tree().paused = false
	self.visible = false

func _on_exit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu)
