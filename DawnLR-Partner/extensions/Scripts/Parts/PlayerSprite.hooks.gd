extends Object

func update(c: ModLoaderHookChain) -> void:
	if (c.reference_object.player_id + 1 > Global.player_power_states.length()):
		Global.player_power_states += "0"
	
	c.execute_next()
