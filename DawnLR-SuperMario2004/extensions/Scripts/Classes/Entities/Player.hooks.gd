extends Object

func die(c: ModLoaderHookChain, pit: bool = false, type: String = "") -> void:
	c.execute_next_async([pit, type])
	
	c.reference_object.get_tree().get_first_node_in_group("GameDestroyer").reset_values()
