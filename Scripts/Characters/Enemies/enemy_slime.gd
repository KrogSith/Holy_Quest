extends CharacterBody2D


const SPEED = 100.0#50.0
const POV = 60.0

@onready var player: CharacterBody2D = get_tree().current_scene.get_node('Player')#get_parent().get_node("Player")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

signal died

enum State {
	Wander,
	Attack
}

var current_state = State.Attack
var rng = RandomNumberGenerator.new()
var dead = false
var hp = 1
var body_inside = false
var damaged = false
var flying = false


func _ready():
	_on_wander_time_timeout()


func _physics_process(delta):
	if !dead:
		state_switch()
		match current_state:
			State.Wander:
				$See_timer.stop()
				if isColliding() == true:
					_on_wander_time_timeout()
			State.Attack:
				$Wander_time.stop()
				if player.dead == false:
					var space_state = get_world_2d().direct_space_state
					var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
					query.exclude = [self]
					var result = space_state.intersect_ray(query)
					if result['collider'] == player:
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


func anim():
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play('Idle')
	else:
		$AnimatedSprite2D.play('Run')
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false


func state_switch():
	var player_distance = player.global_position - global_position
	#if player_distance.length() <= POV:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if player.dead == false:
		if result['collider'] == player:
			$See_timer.start()
			current_state = State.Attack
		else:
			pass


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


func _on_area_2d_body_entered(body):
	if body.name == 'Player':
		body_inside = true
		while body_inside == true:
			if body.damaged == false:
				body.get_damage()
			await get_tree().create_timer(1).timeout


func _on_see_timer_timeout():
	$Wander_time.start(0.1)
	current_state = State.Wander
	$See_timer.stop()


func _on_wander_time_timeout():
	velocity.x = rng.randf_range(-40.0, 40.0)
	velocity.y = rng.randf_range(-40.0, 40.0)
	$Wander_time.wait_time = rng.randf_range(2, 5)


func _on_make_path_timer_timeout():
	makepath()
	$MakePathTimer.start(0.5)


func _on_area_2d_body_exited(body):
	body_inside = false
