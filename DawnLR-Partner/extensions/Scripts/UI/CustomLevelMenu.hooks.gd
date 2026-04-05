extends Object

var cellNodeScene := preload("res://mods-unpacked/DawnLR-Partner/Scenes/UI/SettingsStuff/PartnerConfig.tscn")

func _ready(c: ModLoaderHookChain) -> void:
	var cellNode = cellNodeScene.instantiate()
	
	var children: Array = get_all_children(c.reference_object)
	for i in children.size():
		var child = children[i]
		# This is how I find CharacterSelect Nodes :)
		if (child.has_method("get_custom_characters")):
			cellNode.charSelects.append(child)
	
	c.reference_object.add_child(cellNode)
	
	c.execute_next_async()

func get_all_children(in_node, arr := []):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child, arr)
	return arr
