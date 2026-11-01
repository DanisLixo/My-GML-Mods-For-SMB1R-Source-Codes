extends Object

func on_player_entered(c: ModLoaderHookChain, player: Player) -> void:
	var ref: Node2D = c.reference_object
	
	if ref.get_child_count() <= 1:
		ref.teleport_player(player)
		return
	for i in ref.get_children():
		if i is PickAPathPoint:
			if not i.crossed:
				ref.teleport_player(player)
			return
	ref.queue_free()
