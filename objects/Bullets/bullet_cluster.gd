extends Bullet
class_name BulletCluster

var bullet_cluster_resource = preload("res://resources/bullet/bulled_red_res.tres")
var cluster_number = 1

func _ready():
	timer.start(2)
	
func _on_timer_timeout():
	cluster()
	super()

func _on_body_entered(body):
	#if (body.has_method("enemy") || body.has_method("player") || body.has_method("destructible")):
	cluster()
	queue_free()
	super(body)
	
func cluster():
	var rotation = 360 / cluster_number
	for i in range(cluster_number):
		var cluster_dir = direction.rotated(deg_to_rad(rotation * i))
		SignalBus.shoot.emit(bullet_cluster_resource, position, cluster_dir, 4)
