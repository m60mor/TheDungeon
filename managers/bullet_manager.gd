class_name  BulletManager
extends Node2D

@onready var bullet_basic_scene: PackedScene = preload("res://objects/Bullets/bullet_basic.tscn")
@onready var bullet_slow_scene: PackedScene = preload("res://objects/Bullets/bullet_slow.tscn")

func _ready():
	SignalBus.connect("shoot", build_bullet)

func build_bullet(resource : BulletBaseResource, location : Vector2, direction : Vector2, collision : int) -> void:
	var new_bullet
	if (resource.slow_time > 0): 
		new_bullet = bullet_slow_scene.instantiate() as Bullet
	else:
		new_bullet = bullet_basic_scene.instantiate() as Bullet
	new_bullet.position = location
	new_bullet.direction = (direction - global_position).normalized()
	new_bullet.rotation = new_bullet.direction.angle()
	new_bullet.speed = resource.speed
	new_bullet.slow_multiplier = resource.slow_multiplier
	new_bullet.slow_time = resource.slow_time
	new_bullet.damage = resource.damage
	new_bullet.set_collision_layer_value(4, true)
	new_bullet.set_collision_mask_value(collision, true)
	spawn_bullet(new_bullet)
	new_bullet.sprite.texture = resource.sprite
	new_bullet.collision_shape.shape = resource.shape
	
func spawn_bullet(bullet : Bullet):
	var bullet_container = NodeExtensions.get_bullet_container()
	
	if bullet_container == null:
		return
	
	bullet.add_to_group("Bullet")
	bullet_container.add_child(bullet)
