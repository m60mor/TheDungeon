class_name OptionsMenu
extends Control

#@onready var button = $MarginContainer/VBoxContainer/Button as Button

func _on_close_button_down():
	SignalBus.emit_options_close()
