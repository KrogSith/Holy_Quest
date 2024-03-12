extends Area2D


var speed = 450
var damage = 0.5
var spread = Vector2(randf_range(-1.5, 1.5), randf_range(-1.5, 1.5))


func _physics_process(delta) -> void:
	position += transform.x * speed * delta + spread


func _on_body_entered(body) -> void:
	if body.is_in_group("Enemies"):
		if body.dead == false:
			body.get_damage(damage)
		queue_free()
	else:
		$InWall.play()
		queue_free()
