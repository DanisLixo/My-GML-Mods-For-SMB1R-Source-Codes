extends Object

func physics_update(c: ModLoaderHookChain, delta: float) -> void:
	if (c.reference_object.vine != null):
		if (c.reference_object.player is Partner):
			climb_as_partner(c, delta)
		else:
			c.execute_next([delta])

func climb_as_partner(c: ModLoaderHookChain, delta: float) -> void:
	var player = c.reference_object.player
	var climb_direction = c.reference_object.climb_direction
	var cutscene = c.reference_object.cutscene
	var vine = c.reference_object.vine
	var auto_climb = c.reference_object.auto_climb
	var state_machine = c.reference_object.state_machine
	
	player.velocity.x = 0
	if player.input_direction != 0 and climb_direction == 0 and not cutscene:
		player.direction = -player.input_direction
	player.sprite.scale.x = player.direction * player.gravity_vector.y
	player.global_position.x = vine.global_position.x - (player.physics_params("CLIMB_OFFSET") * player.direction)
	if not cutscene and not auto_climb:
		climb_direction = int(Global.player_action_pressed("move_down", player.player_id)) - int(Global.player_action_pressed("move_up", player.player_id))
	if vine.can_tele and player.global_position.y - 64 < vine.top_point and climb_direction == -1:
		climb_direction = -1
		auto_climb = true
	var climb_speed = player.physics_params("CLIMB_DOWN_SPEED") if climb_direction * player.gravity_vector.y >= 1 else player.physics_params("CLIMB_UP_SPEED")
	player.velocity.y = climb_speed * climb_direction
	player.sprite.play("Climb")
	player.sprite.speed_scale = abs(climb_direction * 1.5)
	player.move()
	if Global.player_action_just_pressed("jump", player.player_id) and not cutscene:
		state_machine.transition_to("Normal")
		player.jump()
		player.velocity.x = 30 * player.input_direction
