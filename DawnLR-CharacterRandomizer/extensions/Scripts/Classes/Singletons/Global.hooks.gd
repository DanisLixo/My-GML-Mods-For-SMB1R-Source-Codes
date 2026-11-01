extends Object

func transition_to_scene(c: ModLoaderHookChain, scene_path = "") -> void:
	var RandomizerSettings = Settings.get_meta("RandomizerMod")
	
	if (scene_path is String && !scene_path.contains("TitleScreen")):
		RandomizerSettings.load_settings()
		
		var every_transition = RandomizerSettings.file.options.every_transition
		var can_randomize = (RandomizerSettings.firstLoad && RandomizerSettings.file.options.randomize_on_start) || !RandomizerSettings.firstLoad
		var next_not_lvl_trans = (scene_path is String && !scene_path.contains("LevelTransition"))
		var current_lvl_trans = (Global.get_tree().current_scene is LevelTransition)
		
		if (every_transition && can_randomize):
			if (next_not_lvl_trans && !current_lvl_trans):
				var randomizer = load("res://mods-unpacked/DawnLR-CharacterRandomizer/Modded/Scripts/Randomizer.gd").new()
				randomizer.start_randomizing(true)
	c.execute_next_async([scene_path])
