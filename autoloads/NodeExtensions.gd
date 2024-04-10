extends Node

const BULLET_CONTAINER : String = "Bullet_container"
const ROOM_CONTAINER : String = "Room_container"
const TELEPORT_CONTAINER : String = "Teleport_container"

func get_bullet_container() -> Node2D:
	return get_tree().get_first_node_in_group(BULLET_CONTAINER)
	
func get_room_container() -> Node2D:
	return get_tree().get_first_node_in_group(ROOM_CONTAINER)
	
func get_teleport_container() -> Node2D:
	return get_tree().get_first_node_in_group(TELEPORT_CONTAINER)
