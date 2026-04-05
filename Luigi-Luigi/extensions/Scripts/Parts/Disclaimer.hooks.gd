extends Object

func _enter_tree(c: ModLoaderHookChain) -> void:
	c.execute_next()
	
	var obj := c.reference_object
	obj.get_node("Title").modulate = Color.hex(0x1a922eff)
	obj.get_node("1").text = "THIS PACK CONTAINS LUIGI."
	obj.get_node("2").text = "PLEASE DO NOT USE IF YOU HAVE A PHOBIA RELATED TO LUIGI, OR GREEN."
	obj.get_node("Enjoy").text = "LUIGI TIME!"
