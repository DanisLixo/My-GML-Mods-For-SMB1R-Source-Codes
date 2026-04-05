extends Object

func warp_back(c: ModLoaderHookChain, player: Player) -> void:
	if (player in c.reference_object.get_tree().get_nodes_in_group("CharPartners-Partners")):
		return
	c.execute_next_async([player])
