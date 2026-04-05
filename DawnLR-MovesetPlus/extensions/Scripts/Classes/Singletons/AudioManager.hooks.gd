extends Object

func load_sfx_map(c: ModLoaderHookChain, json := {}) -> void:
	var manager: AudioManager = c.reference_object
	var mod = manager.get_node("/root/ModLoader/DawnLR-MovesetPlus")
	manager.sfx_library = manager.DEFAULT_SFX_LIBRARY.duplicate()
	manager.sfx_library.merge(mod.MOVESET_PLUS_SFX_LIBRARY)
	
	for i in json:
		manager.sfx_library[i] = json[i]
	print(json)
