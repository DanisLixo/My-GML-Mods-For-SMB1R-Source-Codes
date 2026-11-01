extends Object

func get_resource(c: ModLoaderHookChain, json_file: JSON) -> Resource:
	if (json_file == null):
		return null
	
	return c.execute_next([json_file])

func get_resource_pack_path(c: ModLoaderHookChain,res_path := "", resource_pack := "") -> String:
	var ModResourcer := Global.get_node("/root/ModLoader/BawbLR-EntitiesAPI")
	
	if (res_path.contains("custom_objects-unpacked") || "mods-unpacked"):
		var short_user_path = ModResourcer.convert_custom_objects_path(res_path, true).replace("res://Assets", Global.config_path.path_join("resource_packs/" + resource_pack))
		if FileAccess.file_exists(short_user_path):
			return short_user_path
		
		var user_path = ModResourcer.convert_custom_objects_path(res_path).replace("res://Assets", Global.config_path.path_join("resource_packs/" + resource_pack))
		if FileAccess.file_exists(user_path):
			return user_path
	
	return c.execute_next([res_path, resource_pack])
