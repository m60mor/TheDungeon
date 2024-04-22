extends Control

@onready var inventory : Inventory = preload("res://resources/inventory/player_inventory.tres")
@onready var hotbar_slots : Array = $GridContainer.get_children()

func _ready():
	for i in range(hotbar_slots.size()):
		if (inventory.items[i] != null):
			hotbar_slots[i].update(inventory.items[i])
	hotbar_slots[0].select()

func _unhandled_input(event):
	if (event.is_action_pressed("hotbar_select_slot")):
		var action_event = event as InputEventKey
		var selected_slot_index = action_event.physical_keycode - 49
		for i in range(hotbar_slots.size()):
			hotbar_slots[i].unselect()
		hotbar_slots[selected_slot_index].select()
		print(inventory.get_item(0))
