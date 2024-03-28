class_name  BulletManager
extends Node2D

@onready var base_bullet_scene: PackedScene = preload("res://objects/Bullets/bullet.tscn")

func _ready():
	SignalBus.connect("shoot", build_bullet)

func build_bullet(resource : BulletBaseResource, location : Vector2, direction : Vector2) -> void:
	var new_bullet = base_bullet_scene.instantiate() as Bullet
	new_bullet.sprite = resource.bullet_sprite
	
	new_bullet.position = location
	new_bullet.direction = (direction - global_position).normalized()
	new_bullet.rotation = new_bullet.direction.angle()
	new_bullet.speed = resource.bullet_speed
	spawn_bullet(new_bullet)
	
func spawn_bullet(bullet : Bullet):
	var bullet_container = NodeExtensions.get_bullet_container()
	
	if bullet_container == null:
		return
	
	bullet.add_to_group("Bullet")
	bullet_container.add_child(bullet)
