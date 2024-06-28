extends Node2D
class_name RoomManager

var room_scene : PackedScene = null
var rooms : Array[Room] = []

func _ready():
	pass

func spawn_room(pos, size, room_type, diff):
	room_scene = preload("res://objects/MapObjects/Rooms/room.tscn")
	var new_room = room_scene.instantiate()
	new_room.create_room(pos, size, room_type, diff)
	var room_container = NodeExtensions.get_room_container()
	if room_container == null:
		print("Error no room container")
	room_container.add_child(new_room)
	rooms.append(new_room)
	
func append_doors():
	for i in range(rooms.size()):
		for j in range(7):
			for k in range(7):
				rooms[i].used_positions.append(Vector2i(rooms[i].door_positions[0] + Vector2i(j - 3, k - 3)))
