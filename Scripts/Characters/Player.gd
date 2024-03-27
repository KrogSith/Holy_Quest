extends CharacterBody2D

#var db_shotgun = preload("res://Scenes/Objects/Weapons/weapon_db_shotgun.tscn")
#var sword = preload("res://Scenes/Objects/Weapons/weapon_sword.tscn")
@onready var healthbar : TextureProgressBar = get_parent().get_node("UI/HealthBar")
const SPEED: float = 150.0
var radius: int = 5
var dead: bool = false
var rng = RandomNumberGenerator.new()
var damaged: bool = false
var knockback: Vector2 = Vector2.ZERO
var flying: bool = false
#healthbar.value
var weapones: Array = ["Weapon_Sword", "Weapon_DB_Shotgun"]
var curr_weapon: String = "Weapon_Sword"


func _ready() -> void:
	#$Weapon.add_child(sword.instantiate())
	#$Weapon.add_child(db_shotgun.instantiate())
	load_data()
	

func _physics_process(delta) -> void:
	if !dead:
		movement()
		anim()
		weapon_switch()
	
		move_and_slide()
	else:
		pass
		
	if Input.is_action_just_pressed("game_restart"):
		SavedData.hp = 58
		get_tree().reload_current_scene()


func load_data() -> void:
	healthbar.value = SavedData.hp
	#print(SavedData.curr_weapon)
	curr_weapon = SavedData.curr_weapon
	for weapon in $Weapon.get_children():
			if weapon.name != curr_weapon:
					weapon.equipped = false
			else:
				weapon.equipped = true


func movement() -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED


func anim() -> void:
	#var mouse = get_viewport().get_mouse_position()
	#var res = get_viewport().size
	var mouse_dir = (get_global_mouse_position()-global_position).normalized()
	if mouse_dir.x > 0 and $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = false
	elif mouse_dir.x < 0 and not $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = true

	
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play('Idle')
		$DustParticles.set_emitting(false)
	else:
		$AnimatedSprite2D.play('Run')
		$DustParticles.set_emitting(true)


func weapon_switch() -> void:
	#if Input.is_key_pressed(KEY_2):
		#for weapon in $Weapon.get_children():
				#if weapon.name != 'Weapon_DB_Shotgun':
					#weapon.equipped = false
				#else:
					#weapon.equipped = true
	#elif Input.is_key_pressed(KEY_1):
		#for weapon in $Weapon.get_children():
				#if weapon.name != 'Weapon_Sword':
					#weapon.equipped = false
				#else:
					#weapon.equipped = true
	if Input.is_key_pressed(KEY_1) and curr_weapon != weapones[0]:
		for weapon in $Weapon.get_children():
			if weapon.name != weapones[0]:
					weapon.equipped = false
			else:
				weapon.equipped = true
		curr_weapon = weapones[0]
		SavedData.curr_weapon = curr_weapon
		#print(SavedData.curr_weapon)
	
	elif Input.is_key_pressed(KEY_2) and curr_weapon != weapones[1]:
		for weapon in $Weapon.get_children():
			if weapon.name != weapones[1]:
				weapon.equipped = false
			else:
				weapon.equipped = true
		curr_weapon = weapones[1]
		SavedData.curr_weapon = curr_weapon
		print(SavedData.curr_weapon)


func get_damage(damage_got, dir, force) -> void:
	healthbar.value -= damage_got*15
	SavedData.hp = healthbar.value
	velocity = dir * force
	move_and_slide()
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


func death() -> void:
	var mouse = get_viewport().get_mouse_position()
	var res = get_viewport().size
	$CollisionShape2D.disabled = true
	dead = true
	$DeathSound.play()
	$Weapon.queue_free()
	$CollisionShape2D.queue_free()
	$AnimatedSprite2D.queue_free()
	$DustParticles.queue_free()
	#if $AnimatedSprite2D.flip_h == true:
	#	$Sprite2D.flip_h = true
	#if scale.x == -1:
	#	$Sprite2D.flip_h = true
	#else:
	#	pass
	$Sprite2D.visible = true















