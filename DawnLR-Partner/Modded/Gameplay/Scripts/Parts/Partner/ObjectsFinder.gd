extends RayCast2D

var object = null

func _physics_process(delta: float) -> void:
	if (object != null):
		target_position = (object.global_position) - global_position
	else:
		target_position = Vector2.ZERO
