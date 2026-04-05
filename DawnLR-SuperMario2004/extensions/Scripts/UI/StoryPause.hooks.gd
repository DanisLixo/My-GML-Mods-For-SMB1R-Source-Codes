extends Object

func option_selected(c: ModLoaderHookChain) -> void:
	c.execute_next()
	
	if (c.reference_object.selected_index == 3):
		c.reference_object.get_tree().get_first_node_in_group("GameDestroyer").reset_values()
