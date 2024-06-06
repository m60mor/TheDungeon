class_name RebindButton
extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

@export var action_name: String = "left"

func _ready():
	set_process_input(false)
	set_action_name()
	set_key_text()

func set_action_name() -> void:
	label.text = "Unassigned"
	
	match action_name:
		"left":
			label.text = "Move Left"
		"right":
			label.text = "Move Right"
		"up":
			label.text = "Move Up"
		"down":
			label.text = "Move Down"
		"shoot":
			label.text = "Shoot"
		"pick_up":
			label.text = "Pick Up"
		"drop":
			label.text = "Drop"
			
func set_key_text():
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = ""
	if (action_event is InputEventKey):
		action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	if (action_event is InputEventMouseButton):
		action_keycode = action_event.button_index
	
	button.text = "%s" % action_keycode


func _on_button_toggled(toggled_on):
	if (toggled_on):
		button.text = "Select Key..."
		set_process_input(toggled_on)
		
		for i in get_tree().get_nodes_in_group("ButtonRebind"):
			if (i.action_name != self.action_name):
				i.button.toggle_mode = false
				i.set_process_input(false)
	else:
		for i in get_tree().get_nodes_in_group("ButtonRebind"):
			if (i.action_name != self.action_name):
				i.button.toggle_mode = true
				i.set_process_input(false)
		set_key_text()

func _input(event):
	if not (event is InputEventMouseMotion):
		rebind_action_key(event)
		button.button_pressed = false
	
func rebind_action_key(event) -> void:
	var is_duplicate = false
	var action_event = event
	var action_keycode = ""
	if (action_event is InputEventKey):
		action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	if (action_event is InputEventMouseButton):
		action_keycode = action_event.button_index
	for i in get_tree().get_nodes_in_group("ButtonRebind"):
			if i.action_name!=self.action_name:
				if i.button.text=="%s" %action_keycode:
					is_duplicate=true
					break
	if not is_duplicate:
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name,event)
		set_process_input(false)
		set_key_text()
		set_action_name()
	#InputMap.action_erase_events(action_name)
	#InputMap.action_add_event(action_name, event)
	#
	#set_process_unhandled_key_input(false)
	#set_key_text()
	#set_action_name()
