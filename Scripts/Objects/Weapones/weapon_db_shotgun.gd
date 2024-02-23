extends Node2D


@export var Bullet : PackedScene = preload("res://Scenes/Objects/bullet.tscn")
@export var equipped = false


func _process(delta):
	if equipped == false:
		visible = false
	anim()
	if equipped == true:
		visible = true
		actions()


func anim():
	var mpos = get_global_mouse_position()
	var mouse = get_viewport().get_mouse_position()
	var res = get_viewport().size
	#$Sprite2D.texture = load('res://Textures/Weapones/DBShotgun.png')
	look_at(mpos)
	if mouse.x < res.x/2:
		$Sprite2D.flip_v = true
	elif mouse.x > res.x/2:
		$Sprite2D.flip_v = false


func actions():
	if Input.is_action_just_pressed("attack") and $Timer.time_left == 0:
		shoot()
		$Timer.start()


func shoot():
	for i in range(4):
		var bullet = Bullet.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_transform = $Marker2D.global_transform
	$ShootSound.play()
	$GPUParticles2D.emitting = true
	await get_tree().create_timer(0.25).timeout
	$GPUParticles2D.emitting = false
	#$Gilza.play()


