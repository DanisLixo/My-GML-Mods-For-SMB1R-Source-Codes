extends Object

var exceptions = [
	"bowser", 
	"truebowser", 
	"bowserbro", 
	"bowserjr", 
	"bowserflame", 
	"chainchomp", 
	"drybones", 
	"boo", 
	"boobuddies", 
	"podoboo",
	"spiny", 
	"pokey", 
	"buzzybeetle",
	"piranhaplant", 
	"pipepiranhaplant", 
	"staticpiranhaplant", 
	"firepiranha", 
	"spike", 
	"spiketop",
	"wiggler"
]

func player_entered(chain: ModLoaderHookChain, player: Player) -> void:
	var ref = chain.reference_object
	var moveset = player.get_node("MovesetPlus")
	var is_below_player = player.global_position.y + ref.height < ref.owner.global_position.y if player.gravity_vector.y >= 0 else player.global_position.y - ref.height > ref.owner.global_position.y
	
	var jump_damages = (moveset.to_params("JUMP_DAMAGE") && !moveset.double_jumped) || (moveset.to_params("DOUBLE_JUMP_DAMAGE") && moveset.double_jumped)
	var gliding_damages = (moveset.is_gliding && moveset.to_params("GLIDE_KILL_ENEMIES"))
	var spin_jumping = (moveset.spin_jumping)
	
	if !(player.is_invincible):
		if ((player.actual_velocity_y() >= 15 or is_below_player) && !player.in_water):
			if (jump_damages):
				var enyName = ref.owner.scene_file_path.get_file().get_basename().to_lower()
				if (enyName in exceptions):
					chain.execute_next([player])
					return
				AudioManager.play_sfx("enemy_stomp", ref.owner.global_position)
				player.enemy_bounce_off(false, false)
				ref.invincible_player_hit.emit(player)
				return
			if (gliding_damages):
				AudioManager.play_sfx("enemy_stomp", ref.owner.global_position)
				player.enemy_bounce_off(false, false)
				ref.invincible_player_hit.emit(player)
				return
			if (spin_jumping):
				var enyName = ref.owner.scene_file_path.get_file().get_basename().to_lower()
				if (enyName in exceptions):
					player.enemy_bounce_off(false, false)
					return
				AudioManager.play_sfx("enemy_stomp", ref.owner.global_position)
				player.enemy_bounce_off(false, false)
				ref.invincible_player_hit.emit(player)
				return
	chain.execute_next([player])
