extends Object

func handle_inputs(c: ModLoaderHookChain) -> void:
	if (c.reference_object.selectors.is_empty()):
		return
	
	c.execute_next()
