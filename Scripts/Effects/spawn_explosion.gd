extends AnimatedSprite2D


func _ready() -> void:
	self.play('Appear')
	await get_tree().create_timer(0.5).timeout
	#self.visible = false
	queue_free()

