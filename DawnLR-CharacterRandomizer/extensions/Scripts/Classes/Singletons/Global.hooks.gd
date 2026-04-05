extends Object

func transition_to_scene(c: ModLoaderHookChain, scene_path := "") -> void:
	var characterRandomizer = c.reference_object.get_node("/root/ModLoader/DawnLR-CharacterRandomizer/CharacterRandomizer")
	var p = c.reference_object.get_tree().get_nodes_in_group("Players")
	
	if (characterRandomizer.active && !scene_path.contains("TitleScreen")):
		characterRandomizer.load_settings()
		if (characterRandomizer.file.options.every_transition && !(characterRandomizer.firstLoad && characterRandomizer.file.options.randomize_on_start)
		&& !(scene_path.contains("LevelTransition") || c.reference_object.get_tree().current_scene.name == "LevelTransition")):
			var real_connected = 0
			for i in Settings.file.game.characters:
				if (i != -1):
					real_connected += 1
			for i in real_connected:
				if (i > 0 && characterRandomizer.file.options.randomize_player_one_only):
					continue
				
				Global.player_characters[i] = characterRandomizer.set_new_character(i)
				for j in p:
					if (j != null):
						characterRandomizer.force_player_soft_restart(j)
			
			if (characterRandomizer.firstLoad):
				characterRandomizer.firstLoad = false
	c.execute_next_async([scene_path])
