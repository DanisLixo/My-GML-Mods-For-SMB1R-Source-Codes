extends Object

func get_resource_path(c: ModLoaderHookChain, resource_path := "") -> String:
	var ModResourcer := Global.get_node("/root/ModLoader/BawbLR-EntitiesAPI")
	
	if (resource_path.contains("custom_objects-unpacked")):
		for i in Settings.file.visuals.resource_packs:
			var test = ModResourcer.convert_custom_objects_path(resource_path).replace("res://Assets/", Global.config_path.path_join("resource_packs/" + i + "/"))
			if FileAccess.file_exists(test):
				return test
	return c.execute_next([resource_path])
