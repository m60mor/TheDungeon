class_name Player
extends CharacterBody2D

@onready var pick_up_timer = $PickUpTimer
@onready var hitbox = $Hitbox
@onready var sprite = $AnimatedSprite2D
@onready var sprite_weapon = $SpriteWeapon
@onready var sfx_shoot = $SfxShoot
var sound_shoot = preload("res://assets/Weapons/base.mp3")
var sound_hurt = preload("res://assets/Characters/hurt.mp3")
var sound_pick_up_weapon = preload("res://assets/Weapons/pick_up_weapon.mp3")
const bus = preload("res://default_bus_layout.tres")

@onready var collectibles_detection = $CollectiblesDetection

@onready var hotbar_timer0 = $hotbarTimer0
@onready var hotbar_timer1 = $hotbarTimer1
@onready var hotbar_timer2 = $hotbarTimer2
var hotbar_timer_list : Array[Timer] = []

@export var fire_rate: float = 0
@export var shoot_mode : int = 1
@export var player_speed : float = 1000
@export var bullet_resource : BulletBaseResource = null
@export var inventory : Inventory = preload("res://resources/inventory/player_inventory.tres")

var hp : float = 100
var can_fire0 : bool = true	
var can_fire1 : bool = true	
var can_fire2 : bool = true	
var can_fire_list : Array[bool] = []
var can_teleport : bool = true
var can_pick_up : bool = true
var selected_index : int = 0

func _init():
	SignalBus.connect("drop_item", drop_item)
	SignalBus.connect("heal_player", heal)
	SignalBus.connect("update_selected_index", update_selected_index)
	
func _ready():
	hotbar_timer_list = [hotbar_timer0, hotbar_timer1, hotbar_timer2]
	can_fire_list = [can_fire0, can_fire1, can_fire2]
	update_selected_index(selected_index)

func update_selected_index(index):
	selected_index = index
	fire_rate = inventory.items[selected_index].fire_rate
	shoot_mode = inventory.items[selected_index].shoot_mode
	bullet_resource = inventory.items[selected_index].bullet_resource
	sprite_weapon.texture = inventory.items[selected_index].texture
	sound_shoot = inventory.items[selected_index].sound

func pick_up_item():
	var pick_up_player = AudioStreamPlayer.new()
	pick_up_player.stream = sound_pick_up_weapon
	pick_up_player.set_bus("sfx")
	add_child(pick_up_player)
	pick_up_player.connect("finished", Callable(pick_up_player, "queue_free"))
	if (can_pick_up):
		can_pick_up = false
		var overlapping_areas = collectibles_detection.get_overlapping_areas()
		for i in overlapping_areas:
			i.collect(inventory)
			if (i.has_method("weapon")):
				pick_up_player.play()
				can_fire_list[selected_index] = false
				hotbar_timer_list[selected_index].start(i.cooldown)
			update_selected_index(selected_index)
			break
		pick_up_timer.start(0.3)
	
func drop_item(item : InventoryItem):
	var new_collectable
	if (item.id_type == "w"):
		new_collectable = ItemDrops.weapon_list[item.id][1].instantiate()
		new_collectable.cooldown = hotbar_timer_list[selected_index].time_left
		hotbar_timer_list[selected_index].stop()
	elif (item.id_type == "i"):
		new_collectable = ItemDrops.item_list[item.id][1].instantiate()
		
	new_collectable.position = position - Vector2(16, 16)
	NodeExtensions.get_collectable_container().add_child(new_collectable)
		
func move():
	var input_direction = Vector2(
	Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	if (input_direction !=Vector2.ZERO):
		sprite.play("walk")
	else:
		sprite.play("idle")
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
		if (can_fire_list[selected_index]):
			var dir = -(global_position - get_global_mouse_position()).normalized()
			#sfx_shoot.play()
			var player : AudioStreamPlayer = AudioStreamPlayer.new()
			player.stream = sound_shoot
			player.set_bus("sfx")
			add_child(player)
			player.connect("finished", Callable(player, "queue_free"))
			player.play()
			if (shoot_mode == 1):
				SignalBus.shoot.emit(bullet_resource, position + dir * Vector2(16, 16), dir, 3)
			elif (shoot_mode == 2):		
				SignalBus.shoot.emit(bullet_resource, position + dir * Vector2(16, 16) + dir.rotated(3.14/2) * Vector2(8, 8), dir.rotated(0.1), 3)
				SignalBus.shoot.emit(bullet_resource, position + dir * Vector2(16, 16) + dir.rotated(-3.14/2) * Vector2(8, 8), dir.rotated(-0.1), 3)
			can_fire_list[selected_index] = false
			hotbar_timer_list[selected_index].start(fire_rate)
	
	var body_rotation = get_global_mouse_position() - global_position
	sprite_weapon.rotation = body_rotation.angle()
	if (body_rotation.x > 0):
		sprite.flip_h = false
	elif (body_rotation.x < 0):
		sprite.flip_h = true

func do_damage(dmg, slow_mul = 1, slow_time = 0):
	var hurt_player = AudioStreamPlayer.new()
	hurt_player.stream = sound_hurt
	hurt_player.set_bus("sfx")
	add_child(hurt_player)
	hurt_player.connect("finished", Callable(hurt_player, "queue_free"))
	hurt_player.play()
	hp = hp - dmg
	SignalBus.health_bar_set.emit(hp)
	if (hp <= 0):
		SignalBus.death_screen.emit()
		queue_free()
		
func heal(heal):
	hp = hp + heal
	if (hp > 100):
		hp = 100
	SignalBus.health_bar_set.emit(hp)
	
func _on_pick_up_timer_timeout():
	can_pick_up = true

func _on_hotbar_timer0_timeout():
	can_fire_list[0] = true

func _on_hotbar_timer1_timeout():
	can_fire_list[1] = true

func _on_hotbar_timer2_timeout():
	can_fire_list[2] = true

func player():
	pass
