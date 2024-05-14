extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var damage_timer = $DamageTimer
var damage = 20
var cooldown = 1
var entity_body = null
 
func _on_body_entered(body):
	if (body.has_method("player") or body.has_method("enemy")):
		sprite.frame = 1
		entity_body = body
		print(body.position, body.hitbox.shape.size)
		print(global_position)
		body.do_damage(damage)
		damage_timer.start(cooldown)

func _on_damage_timer_timeout():
	entity_body.do_damage(damage)
	damage_timer.start(cooldown)

func _on_body_exited(body):
	damage_timer.stop()
