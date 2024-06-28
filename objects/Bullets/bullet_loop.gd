extends Bullet
class_name BulletLoop

@onready var loop_timer = $loopTimer
var rotator : float = 0.1

func _ready():
	loop_timer.start(0.15)

func bullet_move(delta : float):
	direction = direction.rotated(rotator)
	position += speed * direction * delta * 2

func _on_body_entered(body):
	if (body.has_method("enemy") || body.has_method("player") || body.has_method("destructible")):
		body.do_damage(damage, slow_multiplier, slow_time)
	queue_free()
	super(body)


func _on_loop_timer_timeout():
	rotator = -rotator
	loop_timer.start(0.3)
	
