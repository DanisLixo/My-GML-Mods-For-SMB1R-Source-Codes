extends RayCast2D

func _physics_process(delta: float) -> void:
	if (owner.thingie.leader != null):
		target_position = (owner.thingie.leader.global_position + Vector2(0, -16)) - global_position
