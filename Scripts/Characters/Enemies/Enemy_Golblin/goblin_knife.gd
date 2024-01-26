extends Area2D


var speed = 350
var damage = 1


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_body_entered(body):
	if body.name == 'Player':
		if body.damaged == false:
			body.get_damage(damage)
			queue_free()
	else:
		if body.name == 'Door':
			queue_free()
		else:
			speed = 0
			$CollisionShape2D.queue_free()
