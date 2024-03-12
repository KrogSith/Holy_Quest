extends Area2D


var work = false
var body_inside = false
var damage = 2


func _ready() -> void:
	$CollisionShape2D.set_deferred("disabled", true)


func start_work() -> void:
	$AnimatedSprite2D.play()
	work = true


func _process(delta) -> void:
	if work == true:
		if $AnimatedSprite2D.frame >= 7 and $AnimatedSprite2D.frame <= 9:
			$CollisionShape2D.set_deferred('disabled', false)
		else: 
			$CollisionShape2D.set_deferred('disabled', true)
	else:
		stop_work()


func stop_work() -> void:
	work = false
	if $AnimatedSprite2D.frame >= 0 and $AnimatedSprite2D.frame <= 2 or $AnimatedSprite2D.frame >= 14 and $AnimatedSprite2D.frame <= 16:
		$AnimatedSprite2D.stop()
		$CollisionShape2D.set_deferred('disabled', true)


func _on_body_entered(body) -> void:
	if body.flying == false:
		body_inside = true
		while body_inside == true:
			if body.damaged == false:
				body.get_damage(damage)
			await get_tree().create_timer(1).timeout
	else: pass


func _on_body_exited(body) -> void:
	body_inside = false
