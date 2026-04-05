extends Object

func transition_to_scene(c: ModLoaderHookChain, scene_path = "") -> void:
	if (Player.CHARACTERS[Global.player_characters[0]] == "Peter Griffin"):
		if (c.reference_object.get_tree().current_scene.name == "LevelTransition"):
			var peterTransition = c.reference_object.get_node("/root/ModLoader/DawnLR-PeterGriffinTransition/PeterTransition")
			
			if (peterTransition != null && !peterTransition.isPlaying):
				peterTransition.play_transition()
				
				await peterTransition.peterTransition_finished
	
	c.execute_next_async([scene_path])
