extends Area2D




func _process(_delta: float) -> void :
	pass

func _on_body_entered(body: Node2D) -> void :
	if "Luna" in body.name:
		get_node("CollisionShape2D").is_queued_for_deletion()
		get_tree().change_scene_to_file("res://Scenes/Levels/Level2.tscn")
