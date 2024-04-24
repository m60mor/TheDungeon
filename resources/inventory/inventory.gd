extends Resource
class_name Inventory

@export var items : Array[InventoryItem]

var inventory_index : int = 0

func _init():
	SignalBus.connect("update_selected_index", update_index)

func update_index(index):
	inventory_index = index

func drop():
	if(items[inventory_index].id > -1):
		SignalBus.drop_item.emit(items[inventory_index])
		items[inventory_index] = InventoryItem.new()
		SignalBus.update_hotbar.emit()

func insert(item : InventoryItem):
	if (!items[inventory_index]):
		items[inventory_index] = item
	else:
		drop()
		items[inventory_index] = item
	#for i in range(items.size()):
		#if !items[i]:
			#items[i] = item
			#break
	SignalBus.update_hotbar.emit()
