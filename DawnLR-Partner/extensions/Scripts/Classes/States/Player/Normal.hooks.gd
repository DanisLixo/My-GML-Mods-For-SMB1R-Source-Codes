extends Object

func handle_animations(c: ModLoaderHookChain) -> void:
	var state: PlayerState = c.reference_object
	if (state.player.player_id == 0 && c.reference_object.player.get_meta("PartnerMod") != null):
		c.reference_object.player.get_meta("PartnerMod").intendedAnim = state.get_animation_name()
	
	c.execute_next()
