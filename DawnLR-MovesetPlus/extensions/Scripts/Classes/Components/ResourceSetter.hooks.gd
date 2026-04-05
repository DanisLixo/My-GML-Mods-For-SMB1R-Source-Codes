extends Object

static func get_resource(c: ModLoaderHookChain, resource: Resource, node: Node = null, assign := false, cache_enabled := true) -> RefCounted:
	Settings.file.visuals.resource_packs.push_front("**Character**")
	
	resource = c.execute_next([resource, node, assign, cache_enabled])
	
	while Settings.file.visuals.resource_packs.has("**Character**"):
		Settings.file.visuals.resource_packs.erase("**Character**")
	return resource

static func get_pure_resource_path(c: ModLoaderHookChain, resource_path := "") -> String:
	var new_path = c.reference_object.get_override_resource_path(resource_path, "**Character**")
	if (resource_path.contains("custom_characters")):
		new_path = new_path.replace(Global.config_path.path_join("custom_characters"), Global.config_path.path_join("custom_characters/" + Player.CHARACTERS[Global.player_characters[0]] + "/Assets/Sprites/Players/CustomCharacters"))
	if FileAccess.file_exists(new_path):
		return new_path
	return c.execute_next([resource_path])

static func get_override_resource_path(c: ModLoaderHookChain, resource_path := "", resource_pack := "") -> String:
	if resource_pack == "**Character**":
		if (Player.CHARACTERS.size() >= Global.player_characters[0]):
			return resource_path.replace("res://Assets", Global.config_path.path_join("custom_characters/" + Player.CHARACTERS[Global.player_characters[0]] + "/Assets"))
	return c.execute_next([resource_path, resource_pack])
