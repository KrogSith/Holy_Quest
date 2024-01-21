extends CharacterBody2D

const MAX_DISTANCE_TO_PLAYER = 100
const MIN_DISTANCE_TO_PLAYER = 50
const SPEED = 130.0#50.0
const POV = 60.0

@onready var player: CharacterBody2D = get_tree().current_scene.get_node('Player')#get_parent().get_node("Player")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@export var Knife : PackedScene = preload('res://Scenes/Characters/Enemies/Enemy_Goblin/goblin_knife.tscn')
#var knife : PackedScene = preload('res://Scenes/Characters/Enemies/Enemy_Goblin/goblin_knife.tscn')

signal died

enum State {
	Wander,
	Attack,
	Idle
}

var current_state = State.Attack
var rng = RandomNumberGenerator.new()
var dead = false
var hp = 3
var distance_to_player
var damaged = false
var flying = false


func _ready():
	_on_wander_time_timeout()
	$KnifePos/AttackTimer.start(1.5)


func _physics_process(delta):
	if !dead:
		if player.dead == true:
			current_state = State.Wander
		#state_switch()
		match current_state:
			State.Wander:
				$See_timer.stop()
				if isColliding() == true:
					_on_wander_time_timeout()
			State.Attack:
				$Wander_time.stop()
				if player.dead == false:
					var dir_to_player = to_local(nav_agent.get_next_path_position()).normalized()
					velocity = dir_to_player*SPEED
					_on_make_path_timer_timeout()
				else:
					_on_see_timer_timeout()
			State.Idle:
				velocity = Vector2.ZERO
				var space_state = get_world_2d().direct_space_state
				var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
				query.exclude = [self]
				var result = space_state.intersect_ray(query)
				if result['collider'] == player:
					attack()
				_on_make_path_timer_timeout()
				#else: current_state = State.Wander
		anim()
		move_and_slide()


func anim():
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play('Idle')
		if player.global_position.x < global_position.x:
			$AnimatedSprite2D.flip_h = true
		elif player.global_position.x > global_position.x:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play('Run')
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false


func makepath():
	nav_agent.target_position = player.global_position


func isColliding():
	var isColliding = false
	if is_on_ceiling() == true or is_on_floor() == true or is_on_wall() == true:
		isColliding = true
	else: pass
	return isColliding


func get_damage():
	hp -= 1
	if hp <= 0:
		death()
	else:
		$HurtSound.play()
		current_state = State.Attack
	damaged = true
	self.visible = false
	await get_tree().create_timer(0.1).timeout
	self.visible = true
	await get_tree().create_timer(0.1).timeout
	self.visible = false
	await get_tree().create_timer(0.1).timeout
	self.visible = true
	damaged = false


func death():
	died.emit()
	$DeathSound.play()
	dead = true
	$AnimatedSprite2D.queue_free()
	$CollisionShape2D.queue_free()
	#$Area2D.queue_free()
	$NavigationAgent2D.queue_free()
	$Wander_time.queue_free()
	$See_timer.queue_free()
	$MakePathTimer.queue_free()
	if $AnimatedSprite2D.flip_h == true:
		$DeadBody.flip_h = true
	else:
		pass
	$DeadBody.visible = true


func _on_see_timer_timeout():
	$Wander_time.start(0.1)
	current_state = State.Wander
	$See_timer.stop()


func _on_wander_time_timeout():
	velocity.x = rng.randf_range(-100.0, 100.0)
	velocity.y = rng.randf_range(-100.0, 100.0)
	$Wander_time.wait_time = rng.randf_range(2, 5)


func _on_make_path_timer_timeout():
	distance_to_player = (player.position - global_position).length()
	#print(distance_to_player)
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result['collider'] == player:
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			makepath()
			current_state = State.Attack
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			makepath_away()
			current_state = State.Attack
		else: current_state = State.Idle #velocity = Vector2.ZERO
	else: makepath()
	$MakePathTimer.start(0.5)
	

func makepath_away():
	var dir = (global_position - player.position).normalized()
	nav_agent.target_position = player.global_position + 100*dir

func attack():
	if $KnifePos/AttackTimer.time_left == 0:
		$KnifePos.look_at(player.position)
		var knife = Knife.instantiate()
		#print(knife)
		get_tree().current_scene.add_child(knife)#call_deferred("add_child", knife)
		#get_parent().call_deferred("add_child", knife)
		knife.transform = $KnifePos/Marker2D.global_transform
		$KnifePos/AudioStreamPlayer2D.play()
		$KnifePos/AttackTimer.start(1)









