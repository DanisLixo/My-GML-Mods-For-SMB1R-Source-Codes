extends Object

func handle_animations(c: ModLoaderHookChain) -> void:
	var state: PlayerState = c.reference_object
	if (state.player.player_id == 0 && c.reference_object.player.get_meta("thingie", state.player) != state.player):
		c.reference_object.player.get_meta("thingie").intendedAnim = state.get_animation_name()
	
	c.execute_next()
