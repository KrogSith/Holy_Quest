extends Area2D


var speed = 350
var damage = 1
@export var knockback_force = 1200
var dir : Vector2


func _physics_process(delta) -> void:
	#position += transform.x * speed * delta
	position += dir * speed * delta


func _on_body_entered(body) -> void:
	if body.name == 'Player':
		if body.damaged == false:
			body.get_damage(damage, dir, knockback_force)
			queue_free()
	else:
		if body.name == 'Door':
			queue_free()
		else:
			speed = 0
			$CollisionShape2D.queue_free()
