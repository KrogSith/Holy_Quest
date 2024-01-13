extends Area2D


var speed = 450


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		body.get_damage()
		body.knockback = body.transform.origin - transform.origin
		queue_free()
	else:
		$InWall.play()
		queue_free()
