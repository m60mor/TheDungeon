class_name Player
extends CharacterBody2D

const id_0 = preload("res://objects/MapObjects/Collectibles/collectable_basic_staff.tscn")
const id_1 = preload("res://objects/MapObjects/Collectibles/collectable_blue_crystal.tscn")
const collectables : Array[PackedScene] = [id_0, id_1]
@onready var timer = $Timer
@onready var pick_up_timer = $PickUpTimer
@onready var collectibles_detection = $CollectiblesDetection


@export var fire_rate: float = 0
@export var player_speed : float = 600
@export var bullet_resource : BulletBaseResource = null
@export var inventory : Inventory

var hp : float = 100
var can_fire : bool = true	
var can_teleport : bool = true
var can_pick_up : bool = true
var selected_index : int = 0

func _init():
	SignalBus.connect("drop_item", drop_item)
	SignalBus.connect("update_selected_index", update_selected_index)
	
func _ready():
	update_selected_index(selected_index)

func update_selected_index(index):
	timer.stop()
	timer.start(0.5)
	selected_index = index
	fire_rate = inventory.items[selected_index].fire_rate
	bullet_resource = inventory.items[selected_index].bullet_resource

func pick_up_item():
	if (can_pick_up):
		can_pick_up = false
		var overlapping_areas = collectibles_detection.get_overlapping_areas()
		for i in overlapping_areas:
			if i.has_method("collectable"):
				i.collect(inventory)
				break
		pick_up_timer.start(0.3)
		update_selected_index(selected_index)
	
func drop_item(item : InventoryItem):
	var new_collectable = collectables[item.id].instantiate()
	new_collectable.position = position - Vector2(16, 16)
	NodeExtensions.get_collectable_container().add_child(new_collectable)
		
func move():
	var input_direction = Vector2(
	Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	velocity = input_direction * player_speed
	move_and_slide()

func _physics_process(_delta):
	move()
	if (Input.is_action_pressed("pick_up")):
		pick_up_item()
	elif (Input.is_action_pressed("drop")):
		inventory.drop()
		update_selected_index(selected_index)
				
	if (Input.is_action_pressed("shoot") and fire_rate > 0):
		if (can_fire):
			var dir = -(global_position - get_global_mouse_position()).normalized()
			SignalBus.shoot.emit(bullet_resource, position + dir * Vector2(16, 16), dir, 3)
			can_fire = false
			timer.start(fire_rate)
	
func do_damage(dmg, slow_mul, slow_time):
	hp = hp - dmg
	print(hp, "__")
	if (hp <= 0):
		queue_free()
	
func _on_timer_timeout():
	can_fire = true
	timer.stop()	
	
func _on_pick_up_timer_timeout():
	can_pick_up = true
	
func player():
	pass
