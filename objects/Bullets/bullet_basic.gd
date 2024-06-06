extends Bullet

func _on_body_entered(body):
	if (body.has_method("enemy") || body.has_method("player") || body.has_method("destructible")):
		body.do_damage(damage, slow_multiplier, slow_time)
	queue_free()
	super(body)
