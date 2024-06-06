extends Node

const mosquito_scene : PackedScene = preload("res://objects/Enemies/enemy_mosquito.tscn")
const fly_scene : PackedScene = preload("res://objects/Enemies/enemy_fly.tscn")
const cloack_scene : PackedScene = preload("res://objects/Enemies/enemy_cloack.tscn")
const goblin_scene : PackedScene = preload("res://objects/Enemies/enemy_goblin.tscn")
const tower1_scene = preload("res://objects/Enemies/stationary_tower1.tscn")

const boss1_scene = preload("res://objects/Enemies/boss1.tscn")

@export var enemy_list = [[30, mosquito_scene], [60, fly_scene], [10, cloack_scene], [10, goblin_scene], [10, tower1_scene]]
#@export var enemy_list = [[10, tower1_scene]]

@export var boss_list = [boss1_scene]

func select_enemy():
	pass
