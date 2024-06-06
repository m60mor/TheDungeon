class_name MainMenu
extends Control

@onready var new_game_button = $MarginContainer/HBoxContainer/VBoxContainer/NewGame as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options as Button
@onready var quit_button = $MarginContainer/HBoxContainer/VBoxContainer/Quit as Button
@onready var options_menu = $OptionsMenu as OptionsMenu

@onready var margin_container = $MarginContainer
@onready var game = preload("res://game/game.tscn") as PackedScene

func _ready():
	SignalBus.connect("options_close", _close_button)

func _on_new_game_button_down():
	get_tree().change_scene_to_packed(game)
	
func _on_options_button_down():
	margin_container.visible = false
	options_menu.visible = true
	
func _close_button():
	margin_container.visible = true
	options_menu.visible = false
	
func _on_quit_button_down():
	get_tree().quit()
