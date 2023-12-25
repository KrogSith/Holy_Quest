extends CharacterBody2D


const SPEED = 30

@export var player: CharacterBody2D
enum State {
	Attack,
	Wander
}
var current_state = State.Wander
var rng = RandomNumberGenerator.new()
var dead = false
var hp = 2


func _ready():
	rng.randomize()


func _physics_process(delta):
	if !dead:
		#draw_line(global_position, player.global_position, Color.RED, 8.0)
		if hp <= 0:
			death()
		state_switch()
		print(current_state)
		match current_state:
			State.Wander:
				velocity.x = 0
				velocity.y = 0
			State.Attack:
				var dir = Vector2(0, 0)
				velocity = dir*SPEED
		anim()
		move_and_slide()


func makepath():
	$NavigationAgent2D.target_position = player.global_position

func _on_timer_timeout():
	makepath()

func anim():
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false


func _on_area_2d_body_entered(body):
	if body.name == 'Player':
		body.death()


func state_switch():
	var player_distance = player.position - position
	if player_distance.length() <= 60:
		$RayCast2D.target_position = player.global_position
		#print($RayCast2D.target_position)
		if $RayCast2D.is_colliding() == false:
			current_state = State.Attack
			$End_Timer.start()


func death():
	$DeathSound.play()
	dead = true
	$AnimatedSprite2D.queue_free()
	$CollisionShape2D.queue_free()
	$RayCast2D.queue_free()
	$Area2D.queue_free()
	$End_Timer.queue_free()
	if $AnimatedSprite2D.flip_h == true:
		$DeadBody.flip_h = true
	else:
		pass
	$DeadBody.visible = true
