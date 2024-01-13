extends StaticBody2D


func _ready():
	$CollisionShape2D.disabled = true


func open():
	$AudioStreamPlayer2D.play()
	$AnimatedSprite2D.play('Open')
	await get_tree().create_timer(1).timeout
	$AnimatedSprite2D.queue_free()
	$Sprite2D.visible = true
	$CollisionShape2D.disabled = true


func close():
	$AudioStreamPlayer2D.play()
	$CollisionShape2D.set_deferred("disabled", false)
	$Sprite2D.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play('Close')