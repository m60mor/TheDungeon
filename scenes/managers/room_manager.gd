extends Node2D
class_name RoomManager

var room_scene : PackedScene = null

func _ready():
	pass

func spawn_room(pos, size):
	room_scene = await preload("res://objects/MapObjects/room.tscn")
	var new_room = room_scene.instantiate()
	new_room.create_room(pos + Vector2(16, 16), size)
	var room_container = NodeExtensions.get_room_container()
	if room_container == null:
		print("Error no room container")
	room_container.add_child(new_room)
