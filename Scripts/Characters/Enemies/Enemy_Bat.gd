extends CharacterBody2D


const SPEED = 30

@export var player: CharacterBody2D
var see_player = false
var rng = RandomNumberGenerator.new()
var dead = false
var hp = 2
#@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
func _ready():
	rng.randomize()


func _physics_process(delta):
	if !dead:
		print($RayCast2D.is_colliding())
		if hp <= 0:
			death()
		if see_player == true and $End_Timer.time_left != 0:
			var dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
			velocity = dir*SPEED
		else:
			see_player = false
			velocity.x = 0
			velocity.y = 0
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
		$Timer.stop()


func _on_sight_body_entered(body):
	$RayCast2D.target_position = player.global_position
	print($RayCast2D.target_position)
	if body.name == 'Player' and $RayCast2D.is_colliding() == false:
		see_player = true
		$Timer.start()
		$End_Timer.start()


func death():
	$DeathSound.play()
	dead = true
	$AnimatedSprite2D.queue_free()
	$CollisionShape2D.queue_free()
	$RayCast2D.queue_free()
	$Area2D.queue_free()
	$Sight.queue_free()
	$NavigationAgent2D.queue_free()
	$Timer.queue_free()
	$End_Timer.queue_free()
	$DeadBody.visible = true
