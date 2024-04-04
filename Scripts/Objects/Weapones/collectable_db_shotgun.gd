extends Area2D


func _ready():
	$AnimationPlayer.play("Squeeze")


func _on_body_entered(body):
	var have_weapon: bool = false
	if body.is_in_group("Player"):
		for i in body.weapones:
			if i == "Weapon_DB_Shotgun":
				have_weapon = true
		if have_weapon == true:
			queue_free()
		else:
			body.weapones.append("Weapon_DB_Shotgun")
			$AnimationPlayer.play("Collect")
			await get_tree().create_timer(0.1).timeout
			queue_free()
