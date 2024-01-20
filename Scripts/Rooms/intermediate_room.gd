extends Node2D


@onready var num_enemies = $EnemyPositions.get_child_count()

var rng = RandomNumberGenerator.new()

const SPAWN_EXPLOSION_SCENE : PackedScene = preload('res://Scenes/Effects/spawn_explosion.tscn')
var enemy_scenes = {
	'enemy_bat': preload('res://Scenes/Characters/Enemies/enemy_bat.tscn'),
	'enemy_slime': preload('res://Scenes/Characters/Enemies/enemy_slime.tscn'),
	'enemy_goblin': preload('res://Scenes/Characters/Enemies/Enemy_Goblin/enemy_goblin.tscn')
}


func open_doors():
	for door in $Doors.get_children():
		door.open()


func close_doors():
	for door in $Doors.get_children():
		door.close()


func random_enemy():
	var size = enemy_scenes.size()
	var random_enemy = enemy_scenes.keys()[randi() % size]
	var enemy = enemy_scenes[random_enemy]
	return enemy.instantiate()
		
		
func spawn_enemies():
	for enemy_pos in $EnemyPositions.get_children():
		var enemy = random_enemy()
		var __ = enemy.died.connect(self.on_enemy_killed)
		enemy.position = enemy_pos.position
		call_deferred("add_child", enemy)
		
		var explosion : AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		explosion.position = enemy_pos.position
		call_deferred("add_child", explosion)


func on_enemy_killed():
	num_enemies -= 1
	if num_enemies == 0:
		open_doors()


func _on_player_detector_body_entered(body):
	$PlayerDetector.queue_free()
	close_doors()
	spawn_enemies()





