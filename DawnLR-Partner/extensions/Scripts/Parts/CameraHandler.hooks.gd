extends Object

func handle_camera(c: ModLoaderHookChain, delta: float) -> void:
	var obj: CameraHandler = c.reference_object
	if obj.get_tree().get_first_node_in_group("Players") == null:
		return
	obj.player = obj.get_tree().get_first_node_in_group("Players")
	
	obj.can_scroll_left = obj.camera_position.x + obj.camera_offset.x > -255
	obj.can_scroll_right = obj.camera_position.x + obj.camera_offset.x < obj.camera_right_limit - 1
	
	if ["Pipe", "Climb", "FlagPole"].has(obj.player.state_machine.state.name):
		obj.handle_vertical_scrolling(delta)
		obj.do_limits()
		obj.camera.global_position = obj.camera_position + obj.camera_offset
		if not obj.player.exiting_pipe:
			return
	
	if not obj.cam_locked:
		if not obj.sp_screen_scroll:
			obj.handle_horizontal_scrolling(delta)
			obj.handle_vertical_scrolling(delta)
			obj.handle_offsets(delta)
		else:
			obj.handle_sp_scrolling()
	
	obj.do_limits()
	obj.camera.global_position = obj.camera_position + obj.camera_offset
	obj.update_camera_barriers()

func do_limits(c: ModLoaderHookChain) -> void:
	c.execute_next()
	
	var cam = c.reference_object
	cam.get_node("../CameraCenterJoint/LeftWall").set_collision_layer_value(1, false)
	cam.get_node("../CameraCenterJoint/RightWall").set_collision_layer_value(1, false)
	
	var wall_enabled := true
	if is_instance_valid(Global.level_editor):
		if Global.level_editor.playing_level == false:
			wall_enabled = false
	cam.get_node("../CameraCenterJoint/LeftWall").set_collision_layer_value(13, wall_enabled)
	var level_exit = false
	if cam.player.state_machine != null:
		level_exit = cam.player.state_machine.state.name == "LevelExit"
	cam.get_node("../CameraCenterJoint/RightWall").set_collision_layer_value(13, wall_enabled and level_exit == false)
	
