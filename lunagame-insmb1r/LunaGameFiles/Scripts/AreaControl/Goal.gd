extends Area2D

@export var next_scene := "res://Scenes/main_menu.tscn"

func _on_body_entered(body: Node2D) -> void :
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file(next_scene)
