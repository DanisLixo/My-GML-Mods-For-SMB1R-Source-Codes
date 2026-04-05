extends Object

func enter(c: ModLoaderHookChain, msg: ={}) -> void:
	c.execute_next_async([msg])
	
	var thing = c.reference_object.player.get_meta("PartnerMod")
	
	if (thing != null):
		if (thing.isEnemy):
			thing.leader.die()
		elif (thing.leader == c.reference_object.player):
			for i in c.reference_object.get_tree().get_nodes_in_group("CharPartners-Partners"):
				if (i == null):
					continue
				if (i.get_meta("PartnerMod").isEnemy):
					i.die_as_enemy()
		
		c.reference_object.set_meta("playerUnderMe", false)

func physics_update(c: ModLoaderHookChain, delta: float) -> void:
	var obj = c.reference_object
	var player = obj.player
	var playerUnderMe = obj.get_meta("playerUnderMe", false)
	
	if (playerUnderMe):
		player.velocity.y = 0
	else:
		player.velocity.y = 125
	player.velocity.x = 0
	player.sprite.scale.x = player.direction
	if player.is_on_floor():
		if obj.can_land:
			obj.can_land = false
			player.global_position.x += 10
			player.direction = -1
		player.sprite.speed_scale = 0
	else:
		player.sprite.speed_scale = 2
	player.play_animation("FlagSlide")
	player.move_and_slide()
