extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Player") and body.healthbar.value < 58:
		body.healthbar.value += 15
		SavedData.hp = body.healthbar.value
		$AnimationPlayer.play("Collect")
		await get_tree().create_timer(0.1).timeout
		queue_free()
