extends Object

func get_resource_pack_path(c: ModLoaderHookChain, res_path := "", resource_pack := "") -> String:
	var ModResourcer = load("res://mods-unpacked/Hom-Simpers/ModResourcer.gd").new()
	var converted_path: String = ModResourcer.convert_custom_objects_path(res_path, true)
	
	var user_path := converted_path.replace("res://Assets", Global.config_path.path_join("resource_packs/" + resource_pack))
	user_path = user_path.replace(Global.config_path.path_join("custom_characters"), Global.config_path.path_join("resource_packs/" + resource_pack + "/Sprites/Players/CustomCharacters/"))
	
	if FileAccess.file_exists(user_path):
		return user_path
	else:
		return c.execute_next([res_path, resource_pack])
