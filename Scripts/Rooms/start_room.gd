extends Node2D


const SPAWN_EXPLOSION_SCENE : PackedScene = preload('res://Scenes/Effects/spawn_explosion.tscn')
#@onready var player: CharacterBody2D = get_tree().current_scene.get_node('Player')


func _ready():
	close_doors()
	#player.position = $PlayerSpawn.position


func open_doors():
	for door in $Doors.get_children():
		door.open()


func close_doors():
	for door in $Doors.get_children():
		door.start_door()


func _on_player_detector_body_entered(body):
	$PlayerDetector.queue_free()
	open_doors()


