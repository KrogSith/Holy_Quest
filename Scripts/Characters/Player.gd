extends CharacterBody2D


@export var Bullet : PackedScene
@onready var healthbar : TextureProgressBar = get_parent().get_node("UI/HealthBar")
const SPEED = 150.0
var radius = 5
var dead = false
var rng = RandomNumberGenerator.new()
var damaged = false
var knockback = Vector2.ZERO
var flying = false


func _physics_process(delta):
	if !dead:
		movement()
		actions()
		anim()
		weapon()
	
		move_and_slide()
	else:
		pass
	if Input.is_action_just_pressed("game_restart"):
		get_tree().reload_current_scene()


func movement():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED


func actions():
	if Input.is_action_just_pressed('shoot') and $Weapon/Timer.time_left == 0:
		shoot()
		$Weapon/Timer.start()


func anim():
	var mouse = get_viewport().get_mouse_position()
	var res = get_viewport().size
	
	if mouse.x < res.x/2:
		$AnimatedSprite2D.flip_h = true
	elif mouse.x > res.x/2:
		$AnimatedSprite2D.flip_h = false
		
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play('Idle')
	else:
		$AnimatedSprite2D.play('Run')


func get_damage():
	healthbar.value -= 15
	#print(healthbar.value)
	if healthbar.value <= 0:
		death()
	else: 
		$HurtSound0.play()
		damaged = true
		velocity = knockback
		self.visible = false
		await get_tree().create_timer(0.1).timeout
		self.visible = true
		await get_tree().create_timer(0.1).timeout
		self.visible = false
		await get_tree().create_timer(0.1).timeout
		self.visible = true
		damaged = false
		velocity = Vector2.ZERO


func death():
	var mouse = get_viewport().get_mouse_position()
	var res = get_viewport().size
	$CollisionShape2D.disabled = true
	dead = true
	$DeathSound.play()
	$Weapon.queue_free()
	$CollisionShape2D.queue_free()
	$AnimatedSprite2D.queue_free()
	if $AnimatedSprite2D.flip_h == true:
		$Sprite2D.flip_h = true
	else:
		pass
	$Sprite2D.visible = true


func weapon():
	var mpos = get_global_mouse_position()
	var mouse = get_viewport().get_mouse_position()
	var res = get_viewport().size
	$Weapon/Sprite2D.texture = load('res://Textures/Weapones/DBShotgun.png')
	$Weapon.look_at(mpos)
	if mouse.x < res.x/2:
		$Weapon/Sprite2D.flip_v = true
	elif mouse.x > res.x/2:
		$Weapon/Sprite2D.flip_v = false


func shoot():
	var bullet = Bullet.instantiate()
	#$Weapon/Sprite2D.position.x -= 5
	#$Weapon/Sprite2D.rotation_degrees -= 5
	owner.add_child(bullet)
	bullet.transform = $Weapon/Marker2D.global_transform
	$Weapon/GPUParticles2D.emitting = true
	$Weapon/ShootSound.play()
	#await get_tree().create_timer(0.5).timeout
	#$Weapon/Gilza.play()















