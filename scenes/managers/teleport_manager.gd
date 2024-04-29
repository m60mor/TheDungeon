extends Node2D
class_name TeleportManager

var teleport_scene : PackedScene = null

func _ready():
	pass

func spawn_teleport(pos, teleport_to, direction):
	teleport_scene = preload("res://objects/MapObjects/Rooms/room_teleport.tscn")
	var new_teleport = teleport_scene.instantiate()
	new_teleport.set_teleport_positions(pos, teleport_to, direction)
	var teleport_container = NodeExtensions.get_teleport_container()
	if teleport_container == null:
		print("Error mno teleport container")
	teleport_container.add_child(new_teleport)
