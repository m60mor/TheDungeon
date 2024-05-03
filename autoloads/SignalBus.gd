extends Node

signal shoot(resource : BulletBaseResource, location : Vector2, direction : Vector2, collision : int)
func emit_shoot(resource : BulletBaseResource, location : Vector2, direction : Vector2, collision : int):
	shoot.emit(resource, location, direction, collision)


signal options_close()
func emit_options_close():
	options_close.emit()
	
	
signal change_room_camera(pos, size)
func emit_change_room_camera(pos, size):
	change_room_camera.emit(pos, size)
	
signal update_hotbar()
func emit_update_hotbar():
	update_hotbar.emit()
	
signal update_selected_index(index)
func emit_update_selected_index(index):
	update_selected_index.emit(index)
	
signal drop_item(item)
func emit_drop_item(item):
	drop_item.emit(item)
	
signal health_bar_damage(dmg)
func emit_health_bar_damage(dmg):
	health_bar_damage.emit(dmg)
	
signal death_screen()
func emit_death_screen():
	death_screen.emit()
