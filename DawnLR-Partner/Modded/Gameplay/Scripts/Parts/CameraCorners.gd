extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_viewport() != null and get_viewport().get_camera_2d() != null:
		global_position = get_viewport().get_camera_2d().get_screen_center_position()
		get_node("Area/LeftWall").position.x = -(get_viewport_rect().size.x / 2)
		get_node("Area/RightWall").position.x = (get_viewport_rect().size.x / 2)
