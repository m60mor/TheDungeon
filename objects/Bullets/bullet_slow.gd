extends Bullet

func _on_body_entered(body):
	if (body.has_method("enemy") || body.has_method("player")):
		body.do_damage(damage, slow_multiplier, slow_time)
	super(body)

func _on_body_exited(body):
	queue_free()
