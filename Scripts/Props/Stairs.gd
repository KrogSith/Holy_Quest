extends Area2D


func _on_body_entered(body) -> void:
	if body.name == "Player":
		$CollisionShape2D.set_deferred("disabled", true)
		SceneTransitor.start_transition_to("res://Scenes/game.tscn")
