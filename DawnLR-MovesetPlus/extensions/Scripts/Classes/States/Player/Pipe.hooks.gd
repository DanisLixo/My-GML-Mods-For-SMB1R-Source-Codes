extends Object

func physics_update(c: ModLoaderHookChain, delta: float) -> void:
	c.execute_next([delta])
	
	var player = c.reference_object.player
	var sprite_multiplier = player.sprite.get_meta("scale_multiplier", Vector2(1, 1))
	player.sprite.scale.x = (player.direction * sprite_multiplier.x)
