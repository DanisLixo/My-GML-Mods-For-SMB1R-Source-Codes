extends Object

func load_entity_map(c: ModLoaderHookChain):
	c.execute_next()
	
	# var extraShit = JSON.parse_string(FileAccess.open("res://mods-unpacked/DawnLR-GameKillerObj/ExtraEntityIDMap.json", FileAccess.READ).get_as_text())
	# c.reference_object.entity_map.merge(extraShit, true)
