extends Resource
class_name InventoryItem

@export var id : int = -1
@export var id_type : String = "w"
@export var name : String = ""
@export var texture : Texture2D
@export var drop_chance : float = 1

@export var bullet_resource : BulletBaseResource
@export var sound = preload("res://assets/Weapons/mechanical.mp3")
@export var fire_rate : float = 0
@export var shoot_mode : int = 1

@export var heal : float = 0
