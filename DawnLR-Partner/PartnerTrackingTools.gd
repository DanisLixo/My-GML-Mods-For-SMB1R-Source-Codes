extends Node

var player: Player

func _enter_tree() -> void:
	player = get_parent()
