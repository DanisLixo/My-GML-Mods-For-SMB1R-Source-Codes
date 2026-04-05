extends Object

func enter(c:ModLoaderHookChain, msg := {}) -> void:
	c.execute_next()
	
	c.reference_object.player.get_node("CameraCenterJoint/RightWall").set_collision_layer_value(13, false)
	
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
