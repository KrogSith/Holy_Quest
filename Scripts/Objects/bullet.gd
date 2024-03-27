extends Area2D


@export var speed: int = 450
@export var damage: float = 0.5
@export var knockback_force: int = 1200
var spread = Vector2(randf_range(-1.5, 1.5), randf_range(-1.5, 1.5))
var dir: Vector2

func _physics_process(delta) -> void:
	position += dir * speed * delta + spread#transform.x * speed * delta + spread


func _on_body_entered(body) -> void:
	if body.is_in_group("Enemies"):
		if body.dead == false:
			body.get_damage(damage, dir, knockback_force)
		queue_free()
	else:
		$InWall.play()
		queue_free()
