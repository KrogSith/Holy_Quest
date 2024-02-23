extends CharacterBody2D

var db_shotgun = preload("res://Scenes/Objects/Weapons/weapon_db_shotgun.tscn")
var sword = preload("res://Scenes/Objects/Weapons/weapon_sword.tscn")
@onready var healthbar : TextureProgressBar = get_parent().get_node("UI/HealthBar")
const SPEED = 150.0
var radius = 5
var dead = false
var rng = RandomNumberGenerator.new()
var damaged = false
var knockback = Vector2.ZERO
var flying = false


func _ready():
	$Weapon.add_child(sword.instantiate())
	#$Weapon.add_child(db_shotgun.instantiate())
	

func _physics_process(delta):
	if !dead:
		movement()
		anim()
		weapon_switch()
	
		move_and_slide()
	else:
		pass
		
	if Input.is_action_just_pressed("game_restart"):
		get_tree().reload_current_scene()


func movement():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED


func anim():
	var mouse = get_viewport().get_mouse_position()
	var res = get_viewport().size
	
	if mouse.x < res.x/2:
		$AnimatedSprite2D.flip_h = true
	elif mouse.x > res.x/2:
		$AnimatedSprite2D.flip_h = false
		
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play('Idle')
		$DustParticles.set_emitting(false)
	else:
		$AnimatedSprite2D.play('Run')
		$DustParticles.set_emitting(true)


func weapon_switch():
	if Input.is_key_pressed(KEY_2):
		for weapon in $Weapon.get_children():
				if weapon.name != 'Weapon_DB_Shotgun':
					weapon.equipped = false
				else:
					weapon.equipped = true
	elif Input.is_key_pressed(KEY_1):
		for weapon in $Weapon.get_children():
				if weapon.name != 'Weapon_Sword':
					weapon.equipped = false
				else:
					weapon.equipped = true
	#if $Weapon.get_child(0).name == 'Weapon_Sword':
		#if Input.is_key_pressed(KEY_2) and $Weapon.get_child(0).animation_in_progress == false:
			#for weapon in $Weapon.get_children():
				#weapon.queue_free()
			#$Weapon.add_child(db_shotgun.instantiate())
	#if $Weapon.get_child(0).name == 'Weapon_DB_Shotgun':
		#if Input.is_key_pressed(KEY_1):
			#for weapon in $Weapon.get_children():
				#weapon.queue_free()
			#$Weapon.add_child(sword.instantiate())


func get_damage(damage_got):
	healthbar.value -= damage_got*15
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















