extends Object

func _ready(chain: ModLoaderHookChain) -> void:
	var characterRandomizer = chain.reference_object.get_node("/root/ModLoader/DawnLR-CharacterRandomizer/CharacterRandomizer")
	characterRandomizer.load_settings()
	if (characterRandomizer.active):
		var real_connected = 0
		for i in Settings.file.game.characters:
			if (i != -1):
				real_connected += 1
		for i in real_connected:
			if (i > 0 && characterRandomizer.file.options.randomize_player_one_only):
				continue
			Global.player_characters[i] = characterRandomizer.set_new_character(i)
		
		if (characterRandomizer.firstLoad):
			characterRandomizer.firstLoad = false
	chain.execute_next_async()
	
