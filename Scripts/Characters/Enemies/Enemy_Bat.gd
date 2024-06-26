extends CharacterBody2D


const SPEED = 50#30.0
const POV = 100.0

signal died()

@onready var player: CharacterBody2D = get_tree().current_scene.get_node('Player')
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var hit_explosion = preload('res://Scenes/Effects/hit_explosion.tscn')

enum State {
	Wander,
	Attack
}

@export var knockback_force: int = 1200
@export var damage: int = 1

var current_state = State.Attack
var rng = RandomNumberGenerator.new()
var dead = false
var hp = 2
var body_inside = false
var damaged = false
var flying = true


func _ready() -> void:
	#$Wander_time.wait_time = rng.randf_range(1, 3)
	_on_wander_time_timeout()


func _physics_process(delta) -> void:
	if !dead:
		state_switch()
		#print(current_state)
		match current_state:
			State.Wander:
				$See_timer.stop()
				if isColliding() == true:
					_on_wander_time_timeout()
				#$Wander_time.autostart = true
				#print($Wander_time.time_left)
			State.Attack:
				$Wander_time.stop()
				if player.dead == false:
					var space_state = get_world_2d().direct_space_state
					var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
					query.exclude = [self]
					var result = space_state.intersect_ray(query)
					if result and result['collider'] == player:
						$MakePathTimer.stop()
						var dir_to_player = global_position.direction_to(player.global_position)
						velocity = dir_to_player*SPEED
					else:
						var dir_to_player = to_local(nav_agent.get_next_path_position()).normalized()
						velocity = dir_to_player*SPEED
						_on_make_path_timer_timeout()
				else:
					_on_see_timer_timeout()
		anim()
		move_and_slide()


func anim() -> void:
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false


func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("Player"):
		body_inside = true
		while body_inside == true:
			if body.damaged == false:
				var dir = velocity.normalized()
				body.get_damage(damage, dir, knockback_force)
			await get_tree().create_timer(1).timeout


func state_switch() -> void:
	var player_distance = player.global_position - global_position
	#if player_distance.length() <= POV:
		#print($RayCast2D.target_position)
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	#print(result)
	if player.dead == false:
		if result and result['collider'].is_in_group("Player"):
			$See_timer.start()
			current_state = State.Attack
		else:
			pass


func makepath() -> void:
	nav_agent.target_position = player.global_position


func isColliding():
	var isColliding = false
	if is_on_ceiling() == true or is_on_floor() == true or is_on_wall() == true:
		isColliding = true
	else: pass
	return isColliding


func get_damage(damage_got, dir, force) -> void:
	add_child(hit_explosion.instantiate())
	velocity = dir * force
	move_and_slide()
	if $AnimatedSprite2D.flip_h == true:
		$HitExplosion.flip_h = true
	hp -= damage_got
	if hp <= 0:
		death()
	else:
		current_state = State.Attack
	damaged = true
	self.visible = false
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.1).timeout
	self.visible = true
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.1).timeout
	self.visible = false
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.1).timeout
	self.visible = true
	velocity = Vector2.ZERO
	damaged = false


func death() -> void:
	died.emit()
	$DeathSound.play()
	dead = true
	$AnimatedSprite2D.queue_free()
	$CollisionShape2D.queue_free()
	$Area2D.queue_free()
	$NavigationAgent2D.queue_free()
	$Wander_time.queue_free()
	$See_timer.queue_free()
	$MakePathTimer.queue_free()
	if $AnimatedSprite2D.flip_h == true:
		$DeadBody.flip_h = true
	else:
		pass
	$DeadBody.visible = true


func _on_wander_time_timeout() -> void:
	velocity.x = rng.randf_range(-20.0, 20.0)
	velocity.y = rng.randf_range(-20.0, 20.0)
	$Wander_time.wait_time = rng.randf_range(2, 5)


func _on_see_timer_timeout() -> void:
	$Wander_time.start(0.1)
	current_state = State.Wander


func _on_make_path_timer_timeout() -> void:
	makepath()
	$MakePathTimer.start(0.5)


func _on_area_2d_body_exited(body) -> void:
	body_inside = false
