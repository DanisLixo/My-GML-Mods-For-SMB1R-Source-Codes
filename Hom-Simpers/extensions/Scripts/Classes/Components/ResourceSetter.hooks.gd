extends Object

static func get_override_resource_path(c: ModLoaderHookChain, resource_path := "", resource_pack := "") -> String:
	var ModResourcer = load("res://mods-unpacked/Hom-Simpers/ModResourcer.gd").new()
	var converted_path: String = ModResourcer.convert_custom_objects_path(resource_path, true)
	
	if resource_pack != "":
		return converted_path.replace("res://Assets", Global.config_path.path_join("resource_packs/" + resource_pack))
	
	return c.execute_next([resource_path, resource_pack])
