extends Node

const pid0 = preload("res://objects/MapObjects/Collectibles/items/collectable_small_health_potion.tscn")
const wid0 = preload("res://objects/MapObjects/Collectibles/weapons/collectable_basic_staff.tscn")
const wid1 = preload("res://objects/MapObjects/Collectibles/weapons/collectable_blue_crystal.tscn")
const wid2 = preload("res://objects/MapObjects/Collectibles/weapons/collectable_fire_staff.tscn")
var mosquito_scene : PackedScene = preload("res://objects/Enemies/enemy_mosquito.tscn")
var fly_scene : PackedScene = preload("res://objects/Enemies/enemy_fly.tscn")
var cloack_scene : PackedScene = preload("res://objects/Enemies/enemy_cloack.tscn")

@export var enemy_list = [[30, mosquito_scene], [60, fly_scene], [10, cloack_scene]]
@export var weapon_list = [[5, wid0], [10, wid1], [10, wid2]]
@export var item_list = [[20, pid0]] 
@export var collectables_list = [] 

#func drop_weapon():
	#var n = randi() % 100
	#for i in weapon_list:
		#if n < i[0]:
			#return i[1]
	#return null
	
func drop_collectable():
	var x : Array
	var n = randi() % 100
	for i in collectables_list:
		if n < i[0]:
			x.append(i[1])
			print(i[1])
	return x

func select_enemy():
	pass
	
