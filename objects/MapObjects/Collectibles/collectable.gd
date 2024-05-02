extends Area2D
class_name Collectable

@export var item_res : InventoryItem

func collect(inventory : Inventory):
	inventory.insert(item_res)
	queue_free()
	
func collectable():
	pass
