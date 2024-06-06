extends Node2D
class_name RoomManager

var room_scene : PackedScene = null
var rooms = []

func _ready():
	pass

func spawn_room(pos, size, room_type):
	room_scene = preload("res://objects/MapObjects/Rooms/room.tscn")
	var new_room = room_scene.instantiate()
	new_room.create_room(pos, size, room_type)
	var room_container = NodeExtensions.get_room_container()
	if room_container == null:
		print("Error no room container")
	room_container.add_child(new_room)
	rooms.append(new_room)
