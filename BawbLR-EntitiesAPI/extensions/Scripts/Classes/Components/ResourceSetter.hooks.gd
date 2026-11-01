extends Object

static func get_override_resource_path(c: ModLoaderHookChain, resource_path := "", resource_pack := "") -> String:
	var ModResourcer := Global.get_node("/root/ModLoader/BawbLR-EntitiesAPI")
	
	if resource_pack != "":
		if (resource_path.contains("custom_objects-unpacked")):
			return ModResourcer.convert_custom_objects_path(resource_path).replace("res://Assets", Global.config_path.path_join("resource_packs/" + resource_pack))
	return c.execute_next([resource_path, resource_pack])
