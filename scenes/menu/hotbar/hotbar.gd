extends Control
class_name Hotbar

@onready var inventory : Inventory = preload("res://resources/inventory/player_inventory.tres")
@onready var hotbar_slots : Array = $GridContainer.get_children()

func _ready():
	update()
	hotbar_slots[0].select()
	SignalBus.update_hotbar.connect(update)
	
func update():
	for i in range(hotbar_slots.size()):
		hotbar_slots[i].update(inventory.items[i])

func _unhandled_input(event):
	if (event.is_action_pressed("hotbar_select_slot")):
		var action_event = event as InputEventKey
		var selected_slot_index = action_event.physical_keycode - 49
		SignalBus.update_selected_index.emit(selected_slot_index)
		for i in range(hotbar_slots.size()):
			hotbar_slots[i].unselect()
		hotbar_slots[selected_slot_index].select()
