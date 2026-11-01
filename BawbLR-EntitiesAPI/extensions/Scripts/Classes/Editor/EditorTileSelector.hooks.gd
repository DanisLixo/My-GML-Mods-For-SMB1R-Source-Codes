extends Object

func _ready(c: ModLoaderHookChain) -> void:
	var sel: EditorTileSelector = c.reference_object
	if (sel.owner == null):
		sel.owner = sel.get_tree().current_scene
		
	c.execute_next()
