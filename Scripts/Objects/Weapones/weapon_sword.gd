extends Node2D


var mouse_dir : Vector2
var body_inside = false
var animation_in_progress = false
@export var damage = 2


func _ready():
	$SlashSprite2D.visible = false


func _process(delta):
	anim()
	actions()
	############################
	if $AnimationPlayer.is_playing() == true:
		animation_in_progress == true
	else: 
		animation_in_progress == false
	############################


func anim():
	mouse_dir = (get_global_mouse_position()-global_position).normalized()
	rotation = mouse_dir.angle()
	if scale.y == 1 and mouse_dir.x < 0:
		scale.y = -1
	elif scale.y == -1 and mouse_dir.x > 0:
		scale.y = 1


func actions():
	if Input.is_action_just_pressed("attack"):
		attack()


func attack():
	$AnimationPlayer.play('Attack')


func _on_area_2d_body_entered(body):
	if body.is_in_group('Enemies'):
		body_inside = true
		while body_inside == true:
			if body.damaged == false:
				body.get_damage(damage)
			await get_tree().create_timer(0.5).timeout
		


func _on_area_2d_body_exited(body):
	body_inside = false
	










	
