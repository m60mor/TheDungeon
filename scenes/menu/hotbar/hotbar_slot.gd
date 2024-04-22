extends Panel

const HOTBAR_ITEM = preload("res://assets/Menu/hotbar_item.png")
const HOTBAR_ITEM_SELECTED = preload("res://assets/Menu/hotbar_item_selected.png")
var item_class = preload("res://scenes/menu/hotbar/hotbar_item.tscn")
var item = null 

var style_default : StyleBoxTexture = null
var style_selected : StyleBoxTexture = null

func _ready():
	style_default = StyleBoxTexture.new()
	style_selected = StyleBoxTexture.new()
	style_default.texture = HOTBAR_ITEM
	style_selected.texture = HOTBAR_ITEM_SELECTED
	item = item_class.instantiate()
	add_child(item)
	
func update(it: InventoryItem):
	item.update(it)

func select():
	add_theme_stylebox_override("panel", style_selected)

func unselect():
	add_theme_stylebox_override("panel", style_default)
