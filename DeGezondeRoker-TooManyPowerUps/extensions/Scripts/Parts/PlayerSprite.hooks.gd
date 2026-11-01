extends Object

func update(chain: ModLoaderHookChain):
	var refobj = chain.reference_object
	var mod_main = refobj.get_tree().root.get_node("ModLoader/DeGezondeRoker-TooManyPowerUps")
	var new_power_states = mod_main.new_power_states
	
	var player_id = refobj.player_id
	var force_power_state = chain.reference_object.force_power_state
	var force_character = chain.reference_object.force_character
	
	chain.reference_object.character = Player.CHARACTERS[int(Global.player_characters[player_id])]
	var power_state = Global.player_power_states[player_id]
	
	if force_power_state == "" and not power_state in Player.POWER_STATES:
		if force_power_state != "":
			power_state = force_power_state
		if force_character != "":
			chain.reference_object.character = force_character
		if chain.reference_object.resource_setter != null:
			var path = "res://Assets/Sprites/Players/" + chain.reference_object.character + "/" + new_power_states[int(power_state)] + ".json"
			var fallback = "res://Assets/Sprites/Players/" + "Mario" + "/" + new_power_states[int(power_state)] + ".json"
			if Player.CHARACTERS.find(chain.reference_object.character) > 3:
				path = path.replace("res://Assets/Sprites/Players/", Global.config_path.path_join("custom_characters/"))
			var spritesheet = load(path)
			if spritesheet == null:
				print(chain.reference_object.character + " has no " + new_power_states[int(power_state)] + "...")
				spritesheet = load(fallback)
			var json = chain.reference_object.resource_setter.get_resource(spritesheet)
			chain.reference_object.sprite_frames = json
			if chain.reference_object.sprite_frames == null: 
				return
			if chain.reference_object.sprite_frames.get_frame_texture(chain.reference_object.animation, chain.reference_object.frame):
				chain.reference_object.offset.y = -(chain.reference_object.sprite_frames.get_frame_texture(chain.reference_object.animation, chain.reference_object.frame).get_height() / 2.0)
		return
	chain.execute_next()
