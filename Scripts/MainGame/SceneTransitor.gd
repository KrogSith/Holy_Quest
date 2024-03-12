extends CanvasLayer


var new_scene: String


func start_transition_to(path_to_scene) -> void:
	new_scene = path_to_scene
	$AnimationPlayer.play("Change_Scene")



func change_scene() -> void:
	assert(get_tree().change_scene_to_file(new_scene) == OK)
