extends Object

func create_translation_from_json(c: ModLoaderHookChain, locale := "") -> void:
	Settings.file.visuals.resource_packs.append("**Character**")
	
	c.execute_next([locale])
	
	Settings.file.visuals.resource_packs.erase("**Character**")
