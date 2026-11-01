extends RayCast2D

var player: Player

func _physics_process(delta: float) -> void:
	if (player != null):
		target_position = (player.global_position + Vector2(0, -16)) - global_position
