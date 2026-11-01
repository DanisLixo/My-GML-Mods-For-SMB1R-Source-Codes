extends Object

func handle_player_interaction(c: ModLoaderHookChain, delta: float) -> void:
	c.execute_next([delta])
	
	var vine := c.reference_object
	for i in vine.hitbox.get_overlapping_areas():
		if i.owner is Partner:
			if (int(Global.player_action_pressed("move_down", i.owner.player_id)) - int(Global.player_action_pressed("move_up", i.owner.player_id))) * i.owner.gravity_vector.y < 0 and i.owner.state_machine.state.name == "Normal":
				i.owner.state_machine.transition_to("Climb", {"Vine": c.reference_object})
			elif i.owner.state_machine.state.name == "Climb" and vine.global_position.y >= vine.top_point and vine.can_grow:
				i.owner.global_position.y -= vine.SPEED * delta

func on_player_entered(c: ModLoaderHookChain, player: Player) -> void:
	if (player is not Partner):
		c.execute_next([player])
