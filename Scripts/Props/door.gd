extends StaticBody2D


func _ready() -> void:
	$CollisionShape2D.disabled = true

func start_door() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
	$Sprite2D.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.animation = 'Close'
	$AnimatedSprite2D.frame = 13


func open() -> void:
	$AudioStreamPlayer2D.play()
	$AnimatedSprite2D.play('Open')
	await get_tree().create_timer(1).timeout
	$AnimatedSprite2D.queue_free()
	$Sprite2D.visible = true
	$CollisionShape2D.disabled = true


func close() -> void:
	$AudioStreamPlayer2D.play()
	$CollisionShape2D.set_deferred("disabled", false)
	$Sprite2D.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play('Close')
