extends Control

@onready var texture_rect : TextureRect = $TextureRect
var item_name : String = ""

func _ready():
	texture_rect.position = Vector2(2, 2)
	#texture_rect.size = Vector2(32, 32)
	
func update(item: InventoryItem):
	item_name = item.name
	texture_rect.texture = item.texture
