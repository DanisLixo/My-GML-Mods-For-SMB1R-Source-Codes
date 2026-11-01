extends Object

func transition_to_scene(c: ModLoaderHookChain, scene_path = "") -> void:
	var transition := Global.get_node("/root/ModLoader/BawbLR-SMASTransition/TransitionLayer")
	var fade_transition = bool(Settings.file.visuals.transition_animation)
	
	if Global.transitioning_scene:
		return
		
	#if (PipeArea.exiting_pipe_id != -1):
	transition.pixelate_screen()
	Settings.file.visuals.transition_animation = true
	await Global.get_tree().create_timer(0.3, true).timeout
	
	c.execute_next_async([scene_path])
	
	await Global.transition_finished
	
	transition.unpixelate_screen()
	Settings.file.visuals.transition_animation = fade_transition
