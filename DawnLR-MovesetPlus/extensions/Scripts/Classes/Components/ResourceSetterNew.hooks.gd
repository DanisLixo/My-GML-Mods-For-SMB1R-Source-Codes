extends Object

func get_resource(c: ModLoaderHookChain, json_file: JSON) -> Resource:
	Settings.file.visuals.resource_packs.push_front("**Character**")
	
	var resource = c.execute_next([json_file])
	
	while Settings.file.visuals.resource_packs.has("**Character**"):
		Settings.file.visuals.resource_packs.erase("**Character**")
	return resource

func get_config_file(c: ModLoaderHookChain, resource_pack := "") -> void:
	if (resource_pack != "**Character**"):
		c.execute_next([resource_pack])
		return
	
	var bigDic = Global.config_path.path_join("custom_characters/" + Player.CHARACTERS[Global.player_characters[0]] + "/Assets/config.json")
	if FileAccess.file_exists(bigDic):
		c.reference_object.config_to_use = JSON.parse_string(FileAccess.open(bigDic, FileAccess.READ).get_as_text())
		if c.reference_object.config_to_use == null:
			Global.log_error("Error parsing Config File! (" + resource_pack + ")")
			c.reference_object.config_to_use = {}

func get_resource_pack_path(c: ModLoaderHookChain, res_path := "", resource_pack := "") -> String:
	if (resource_pack != "**Character**"):
		return c.execute_next([res_path, resource_pack])
	
	var user_path := res_path.replace("res://Assets", Global.config_path.path_join("custom_characters/" + Player.CHARACTERS[Global.player_characters[0]] + "/Assets"))
	if (res_path.contains("custom_characters")):
		user_path = user_path.replace(Global.config_path.path_join("custom_characters"), Global.config_path.path_join("custom_characters/" + Player.CHARACTERS[Global.player_characters[0]] + "/Assets/Sprites/Players/CustomCharacters"))
	
	if (res_path == user_path):
		return c.execute_next([res_path, resource_pack])
	
	if FileAccess.file_exists(user_path):
		return user_path
	else:
		return res_path
