extends Node2D


var mouse_dir : Vector2
var body_inside: bool = false
var animation_in_progress: bool = false
@export var damage: int = 3
@export var equipped: bool = true
@export var knockback_force: int = 1200


func _ready() -> void:
	$SlashSprite2D.visible = false
	$Sword/Sprite2D/Area2D/CollisionShape2D.set_deferred("disabled", true)


func _process(delta) -> void:
	if equipped == false:
		visible = false
	anim()
	if equipped == true:
		visible = true
		actions()
	############################
	if $AnimationPlayer.is_playing() == true:
		animation_in_progress == true
	else: 
		animation_in_progress == false
	############################


func anim() -> void:
	mouse_dir = (get_global_mouse_position()-global_position).normalized()
	rotation = mouse_dir.angle()
	if scale.y == 1 and mouse_dir.x < 0:
		scale.y = -1
	elif scale.y == -1 and mouse_dir.x > 0:
		scale.y = 1


func actions() -> void:
	if Input.is_action_just_pressed("attack") and $AnimationPlayer.is_playing() == false:
		attack()


func attack() -> void:
	$AnimationPlayer.play('Attack')
	$AudioStreamPlayer2D.play()


func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group('Enemies'):
		body_inside = true
		while body_inside == true:
			if body.damaged == false:
				body.get_damage(damage, mouse_dir, knockback_force)
			await get_tree().create_timer(0.5).timeout
		


func _on_area_2d_body_exited(body) -> void:
	body_inside = false












