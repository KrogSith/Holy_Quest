extends Area2D


var speed = 450
var damage = 1
var spread = Vector2(randf_range(-1, 1), randf_range(-1, 1))


func _physics_process(delta):
	position += transform.x * speed * delta + spread


func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		body.get_damage(damage)
		queue_free()
	else:
		$InWall.play()
		queue_free()
