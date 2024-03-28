extends Node

const BULLET_CONTAINER : String = "Bullet_container"

func get_bullet_container() -> Node2D:
	return get_tree().get_first_node_in_group(BULLET_CONTAINER)
