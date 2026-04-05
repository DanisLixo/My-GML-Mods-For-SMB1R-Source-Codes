extends Object

func physics_update(c: ModLoaderHookChain, delta: float) -> void:
	c.execute_next([delta])
	
	var player = c.reference_object.player
	var sprite_multiplier = player.sprite.get_meta("scale_multiplier", Vector2(1, 1))
	player.sprite.scale.x = (player.direction * sprite_multiplier.x)
	
func exit(c: ModLoaderHookChain) -> void:
	var moveset = c.reference_object.player.get_meta("movesetPlus")
	if (moveset.to_params("JUMPS_AFTER_FLAGPOLE_DOWN")):
		moveset.is_flag_jumping = true
		c.reference_object.player.direction = 1
		c.reference_object.player.velocity.x = c.reference_object.player.WALK_SPEED
		c.reference_object.player.jump()
		moveset.is_flag_jumping = false
