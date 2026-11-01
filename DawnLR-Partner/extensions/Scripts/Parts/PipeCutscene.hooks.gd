extends Object

func _ready(c: ModLoaderHookChain) -> void:
	c.execute_next()
	
	var cutManager = c.reference_object
	var count := 0
	
	for i in Global.player_characters.size():
		if (i == 0 || Global.player_characters[i] == -1 || Settings.file.partners.behavior[i] == 1):
			continue
		
		count += 1
		
		var ogPlayer: PlayerSprite = cutManager.get_node("Player1")
		var playerAgain: PlayerSprite = load("res://Scripts/Parts/PlayerSprite.gd").new()
		playerAgain.add_child(load("res://Scripts/Classes/Components/ResourceSetterNew.gd").new())
		playerAgain.add_child(load("res://mods-unpacked/DawnLR-Partner/Modded/Gameplay/Scripts/Parts/Partner/PartnerPlayerSpriteWalkScript.gd").new())
		playerAgain.player_id = i
		playerAgain.resource_setter = playerAgain.get_child(0)
		
		playerAgain.sprite_frames = ogPlayer.sprite_frames
		playerAgain.animation = ogPlayer.animation
		playerAgain.speed_scale = ogPlayer.speed_scale
		
		playerAgain.offset = ogPlayer.offset
		
		playerAgain.global_position.x = ogPlayer.global_position.x - (12 * count)
		playerAgain.global_position.y = ogPlayer.global_position.y
		
		playerAgain.z_index = ogPlayer.z_index
		cutManager.add_child(playerAgain)
		playerAgain.play()
