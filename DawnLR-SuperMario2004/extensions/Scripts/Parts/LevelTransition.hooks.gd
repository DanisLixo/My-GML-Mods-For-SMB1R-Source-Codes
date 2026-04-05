extends Object

func _ready(c:ModLoaderHookChain) -> void:
	c.execute_next_async()
	
	c.reference_object.get_tree().get_first_node_in_group("GameDestroyer").reset_values()
