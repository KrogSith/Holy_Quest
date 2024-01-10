extends CharacterBody2D


const SPEED = 50.0
const POV = 60.0

@onready var player: CharacterBody2D = get_parent().get_node("Player")
#@export var player: CharacterBody2D

enum State {
	Wander,
	Attack
}

var current_state = State.Wander
var rng = RandomNumberGenerator.new()
var dead = false
var hp = 1


func _ready():
	#$Wander_time.wait_time = rng.randf_range(1, 3)
	_on_wander_time_timeout()


func _physics_process(delta):
	if !dead:
		#print($See_timer.time_left)
		if hp <= 0:
			death()
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
					var dir_to_player = global_position.direction_to(player.global_position)
					velocity = dir_to_player*SPEED
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
	var player_distance = player.position - position
	if player_distance.length() <= POV:
		#print($RayCast2D.target_position)
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if player.dead == false:
			#print(result['collider'])
			if result['collider'] == player:
				$See_timer.start()
				current_state = State.Attack
			else:
				pass


#func obstacles():
	#var px = player.global_position.x
	#var py = player.global_position.y
	#var sx = global_position.x
	#var sy = global_position.x
	#if is_on_wall():
		#if py >


func isColliding():
	var isColliding = false
	if is_on_ceiling() == true or is_on_floor() == true or is_on_wall() == true:
		isColliding = true
	else: pass
	return isColliding


func death():
	$DeathSound.play()
	dead = true
	$AnimatedSprite2D.queue_free()
	$CollisionShape2D.queue_free()
	$Area2D.queue_free()
	if $AnimatedSprite2D.flip_h == true:
		$DeadBody.flip_h = true
	else:
		pass
	$DeadBody.visible = true


func _on_area_2d_body_entered(body):
	if body.name == 'Player':
		body.get_damage()


func _on_see_timer_timeout():
	$Wander_time.start(0.1)
	current_state = State.Wander
	$See_timer.stop()


func _on_wander_time_timeout():
	velocity.x = rng.randf_range(-40.0, 40.0)
	velocity.y = rng.randf_range(-40.0, 40.0)
	$Wander_time.wait_time = rng.randf_range(2, 5)


