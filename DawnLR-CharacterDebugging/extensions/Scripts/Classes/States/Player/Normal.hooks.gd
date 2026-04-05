extends Object

func handle_animations(c: ModLoaderHookChain) -> void:
	var state: PlayerState = c.reference_object
	
	if (state.player.player_id == 0):
		state.get_meta("debugger").intendedAnim = state.get_animation_name()
	
	c.execute_next()
