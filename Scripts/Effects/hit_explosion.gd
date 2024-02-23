extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.play('Hit')
	await get_tree().create_timer(0.2).timeout
	#self.visible = false
	queue_free()
