extends Node

const mosquito_scene : PackedScene = preload("res://objects/Enemies/enemy_mosquito.tscn")
const fly_scene : PackedScene = preload("res://objects/Enemies/enemy_fly.tscn")
const cloack_scene : PackedScene = preload("res://objects/Enemies/enemy_cloack.tscn")
const goblin_scene : PackedScene = preload("res://objects/Enemies/enemy_goblin.tscn")
const tower1_scene = preload("res://objects/Enemies/stationary_tower1.tscn")
const skeleton_scene = preload("res://objects/Enemies/enemy_skeleton.tscn")
const rocke_scene = preload("res://objects/Enemies/enemy_rock.tscn")

const boss1_scene = preload("res://objects/Enemies/boss1.tscn")

@export var enemy_list = [[1, mosquito_scene], [1, fly_scene], [1, skeleton_scene], [2, cloack_scene], [2, goblin_scene], [3, tower1_scene]]
#@export var enemy_list = [[10, tower1_scene]]

@export var boss_list = [boss1_scene]

func select_enemy(difficulty):
	var i = 0
	while i < 50:
		var selected = randi() % enemy_list.size()
		if (enemy_list[selected][0] <= difficulty):
			return enemy_list[selected][1]
		i += 1
	return enemy_list[1][1]
		
