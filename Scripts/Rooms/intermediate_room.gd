extends Node2D


#@onready var num_enemies = $EnemyPositions.get_child_count()
var num_enemies = 0

var rng = RandomNumberGenerator.new()

const SPAWN_EXPLOSION_SCENE : PackedScene = preload('res://Scenes/Effects/spawn_explosion.tscn')
var enemy_scenes = {
	'enemy_bat': preload('res://Scenes/Characters/Enemies/enemy_bat.tscn'),
	'enemy_slime': preload('res://Scenes/Characters/Enemies/enemy_slime.tscn'),
	'enemy_goblin': preload('res://Scenes/Characters/Enemies/Enemy_Goblin/enemy_goblin.tscn')
}


func open_doors() -> void:
	for door in $Doors.get_children():
		door.open()


func start_traps() -> void:
	for trap in $Traps.get_children():
		trap.start_work()


func close_doors() -> void:
	for door in $Doors.get_children():
		door.close()


func stop_traps() -> void:
	for trap in $Traps.get_children():
		trap.stop_work()


func random_enemy():
	var size = enemy_scenes.size()
	var random_enemy = enemy_scenes.keys()[randi() % size]
	var enemy = enemy_scenes[random_enemy]
	return enemy.instantiate()
		
		
func spawn_enemies() -> void:
	for enemy_pos in $EnemyPositions.get_children():
		var enemy = random_enemy()
		var __ = enemy.died.connect(self.on_enemy_killed)
		enemy.position = enemy_pos.position
		call_deferred("add_child", enemy)
		num_enemies += 1
		print(num_enemies)
		
		var explosion : AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		explosion.position = enemy_pos.position
		call_deferred("add_child", explosion)


func on_enemy_killed() -> void:
	num_enemies -= 1
	print('Num of enemies left:', num_enemies)
	if num_enemies == 0:
		open_doors()
		stop_traps()


func _on_player_detector_body_entered(body) -> void:
	if body.is_in_group("Player"):
		$PlayerDetector.queue_free()
		close_doors()
		start_traps()
		spawn_enemies()





