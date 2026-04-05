extends Object

var cellNodeScene := preload("res://mods-unpacked/DawnLR-MovesetPlus/Scenes/UI/CharPackSettingsNode.tscn")

func _ready(c: ModLoaderHookChain) -> void:
	var children: Array = get_all_children(c.reference_object)
	for child in children:
		# This is how I find CharacterSelect Nodes :)
		if (child.has_method("get_custom_characters")): 
			var cellNode = cellNodeScene.instantiate()
			child.add_sibling(cellNode)
			cellNode.charSelect = child
	
	c.execute_next_async()

func get_all_children(in_node, arr := []):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child, arr)
	return arr
