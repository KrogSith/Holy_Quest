extends Node2D


const SPAWN_EXPLOSION_SCENE : PackedScene = preload('res://Scenes/Effects/spawn_explosion.tscn')


func close_doors():
	for door in $Doors.get_children():
		door.close()


func _on_player_detector_body_entered(body):
	$PlayerDetector.queue_free()
	close_doors()


