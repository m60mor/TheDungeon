extends Node

signal shoot(resource : BulletBaseResource, location : Vector2, direction : Vector2, collision : int)
func emit_shoot(resource : BulletBaseResource, location : Vector2, direction : Vector2, collision : int):
	shoot.emit(resource, location, direction, collision)


signal options_close()
func emit_options_close():
	options_close.emit()
	
signal resume()
func emit_resume():
	resume.emit()
	
signal pause_menu()
func emit_pause_menu():
	pause_menu.emit()
		
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
	
signal health_bar_set(health)
func emit_health_bar_set(health):
	health_bar_set.emit(health)
	
signal heal_player(heal)
func emit_heal_player(heal):
	heal_player.emit(heal)
	
signal death_screen()
func emit_death_screen():
	death_screen.emit()
	
signal win_screen()
func emit_win_screen():
	win_screen.emit()
	
signal reset_inventory()
func emit_reset_inventory():
	reset_inventory.emit()
