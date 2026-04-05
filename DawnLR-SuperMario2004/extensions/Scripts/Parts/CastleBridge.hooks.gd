extends Object

func _ready(c: ModLoaderHookChain) -> void:
	c.execute_next_async()
	
	c.reference_object.get_tree().get_first_node_in_group("GameDestroyer").castleAxe = self

func destroy_bridge(c: ModLoaderHookChain, player: Player):
	c.execute_next_async([player])
	
	c.reference_object.get_tree().get_first_node_in_group("GameDestroyer").canProgressWorsing = false
	c.reference_object.get_tree().get_first_node_in_group("GameDestroyer").start_restore(0.0)
