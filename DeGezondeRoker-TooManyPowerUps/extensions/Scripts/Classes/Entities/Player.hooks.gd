extends Object

class EditorBugHandler extends Node:
	func _exit_tree() -> void:
		if (Global.current_game_mode == Global.GameMode.LEVEL_EDITOR):
			for i in Global.player_power_states.length():
				Global.player_power_states[i] = "2"

func _ready(chain: ModLoaderHookChain) -> void:
	spawn_and_go_ready_with_await(chain)
	
func spawn_and_go_ready_with_await(chain: ModLoaderHookChain) -> void:
	var start := false
	while (Global.current_game_mode == Global.GameMode.LEVEL_EDITOR && !LevelEditor.playing_level):
		if !start:
			chain.execute_next()
			start = true
		await Global.get_tree().process_frame
	
	if (!is_instance_valid(chain.reference_object) && chain.reference_object != null):
		chain.reference_object = Global.get_tree().get_first_node_in_group("Players")
	
	if (chain.reference_object == null):
		return
	
	var refobj = chain.reference_object
	var mod_main = refobj.get_tree().root.get_node("ModLoader/DeGezondeRoker-TooManyPowerUps")
	var new_power_states = mod_main.new_power_states
	
	# Create a new palette node for any modded power-up palettes
	var palette = load("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/ModdedPalette.tscn")
	palette = palette.instantiate()
	refobj.add_child(palette)
	# Just get the modded palette based on the vanilla palette's path
	var json_path = (refobj.CHARACTER_PALETTES[int(Global.player_characters[refobj.player_id])]).replace("ColourPalette", "ModdedPalette")
	
	refobj.get_node("ModdedPalette/ResourceSetterNew").json_path = json_path
	refobj.get_node("ModdedPalette").position.y -= 0x40
	
	var shellcollision = load("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/ShellCollision.tscn")
	shellcollision = shellcollision.instantiate()
	refobj.add_child(shellcollision)
	var hammerstate = load("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerStates/HammerSuit.tscn")
	hammerstate = hammerstate.instantiate()
	refobj.get_node_or_null("PowerStates").add_child(hammerstate)
	var bubblestate = load("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerStates/Bubble.tscn")
	bubblestate = bubblestate.instantiate()
	refobj.get_node_or_null("PowerStates").add_child(bubblestate)
	var boomerstate = load("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerStates/BoomerangSuit.tscn")
	boomerstate = boomerstate.instantiate()
	refobj.get_node_or_null("PowerStates").add_child(boomerstate)
	var bnuuystate = load("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerStates/Bunny.tscn")
	bnuuystate = bnuuystate.instantiate()
	refobj.get_node_or_null("PowerStates").add_child(bnuuystate)
	var ballstate = load("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerStates/SuperBall.tscn")
	ballstate = ballstate.instantiate()
	refobj.get_node_or_null("PowerStates").add_child(ballstate)
	var shellstate = load("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerStates/Shell.tscn")
	shellstate = shellstate.instantiate()
	refobj.get_node_or_null("PowerStates").add_child(shellstate)
	var turnipstate = load("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerStates/Turnip.tscn")
	turnipstate = turnipstate.instantiate()
	refobj.get_node_or_null("PowerStates").add_child(turnipstate)
	
	chain.reference_object.add_child(EditorBugHandler.new())
	
	
	# Unless there is a way to change the POWER_STATES constant in player.gd, we need to overwrite anything related to the power-up state after _ready()
	# This is only necessary if the player has a modded power-up
	# Another option would be to simply replace this entire function, but for this function that doesn't seem ideal
	var power_state_backup = Global.player_power_states[refobj.player_id]
	if int(power_state_backup) >= 3:
		Global.player_power_states[refobj.player_id] = "2"
	
	if !start:
		chain.execute_next()
	
	print(power_state_backup)
	if int(power_state_backup) >= 3:
		Global.player_power_states[refobj.player_id] = power_state_backup
		var power_name = new_power_states[int(power_state_backup)]
		refobj.power_state = refobj.get_node("PowerStates/" + power_name)
	
	var force_powerup = mod_main.config_forcepowerup
	
	if force_powerup != 0:
		var power_name = new_power_states[int(force_powerup)]
		refobj.power_state = refobj.get_node("PowerStates/" + power_name)
	
#func get_character_sprite_path(chain: ModLoaderHookChain, power_stateto_use: String = chain.reference_object.power_state.state_name) -> String:
	#return chain.execute_next([power_stateto_use])

func handle_invincible_palette(chain: ModLoaderHookChain) -> void:
	var refobj = chain.reference_object
	var mod_main = refobj.get_tree().root.get_node("ModLoader/DeGezondeRoker-TooManyPowerUps")
	var new_power_states = mod_main.new_power_states
	
	if Input.is_action_just_pressed("debug_reload"):
		chain.reference_object.get_node("ModdedPalette").visible = !chain.reference_object.get_node("ModdedPalette").visible
		
	chain.execute_next()
	# This function also reads from the constant power states array. The resource pack modifies the actual palette file, this just tells it to past the first three rows
	var current_power_state = new_power_states.find(chain.reference_object.power_state.state_name)
	if current_power_state >= 3:
		var index = current_power_state - 3
		chain.reference_object.sprite.material.set_shader_parameter("player_palette", chain.reference_object.get_node("ModdedPalette").texture)
		chain.reference_object.sprite.material.set_shader_parameter("palette_idx", index)

#func enemy_bounce_off(chain: ModLoaderHookChain, add_combo := true, award_score := true) -> void:
	#var player = chain.reference_object
	#var backup_vel = player.velocity.y
	#chain.execute_next([add_combo, award_score])
			#player.velocity.y = backup_vel
	#if player.power_state.state_name == "Shell":
		#if player.power_state.sliding == true:
			#player.velocity.y = backup_vel
			
func damage(chain: ModLoaderHookChain, type) -> void:
	var player = chain.reference_object
	
	if player.can_hurt == false or player.is_invincible:
		chain.execute_next_async([type])
		return

	player.attacking = false # This is needed because some power-ups use the attacking variable differently from vanilla, causing it to not get reset sometimes
	chain.execute_next_async([type])
