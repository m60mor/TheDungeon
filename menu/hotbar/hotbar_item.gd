extends Control

@onready var texture_rect : TextureRect = $TextureRect
var item_name : String = ""
var item_id : int

func _ready():
	texture_rect.position = Vector2(2, 2)
	
func update(item: InventoryItem):
	item_id = item.id
	item_name = item.name
	texture_rect.texture = item.texture
