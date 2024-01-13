extends AnimatedSprite2D


func _ready():
	self.play('Appear')
	await get_tree().create_timer(0.5).timeout
	self.visible = false

