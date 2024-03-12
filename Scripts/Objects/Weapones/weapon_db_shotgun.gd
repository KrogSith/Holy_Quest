extends Node2D


var mouse_dir : Vector2


@export var Bullet : PackedScene = preload("res://Scenes/Objects/bullet.tscn")
@export var equipped = false


func _process(delta) -> void:
	if equipped == false:
		visible = false
	anim()
	if equipped == true:
		visible = true
		actions()


#func anim():
	#var mpos = get_global_mouse_position()
	#var mouse = get_viewport().get_mouse_position()
	#var res = get_viewport().size
	##$Sprite2D.texture = load('res://Textures/Weapones/DBShotgun.png')
	#look_at(mpos)
	#if mouse.x < res.x/2:
		#$Sprite2D.flip_v = true
	#elif mouse.x > res.x/2:
		#$Sprite2D.flip_v = false



func anim() -> void:
	mouse_dir = (get_global_mouse_position()-global_position).normalized()
	rotation = mouse_dir.angle()
	if scale.y == 1 and mouse_dir.x < 0:
		scale.y = -1
	elif scale.y == -1 and mouse_dir.x > 0:
		scale.y = 1


func actions() -> void:
	if Input.is_action_just_pressed("attack") and $Timer.time_left == 0:
		shoot()
		$Timer.start()


func shoot() -> void:
	for i in range(4):
		var bullet = Bullet.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_transform = $Sprite2D/Marker2D.global_transform
	$AnimationPlayer.play("Shot")
	$ShootSound.play()
	$GPUParticles2D.emitting = true
	await get_tree().create_timer(0.25).timeout
	$GPUParticles2D.emitting = false
	#$Gilza.play()


