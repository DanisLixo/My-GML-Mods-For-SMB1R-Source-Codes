extends Object

func get_resource(c: ModLoaderHookChain, resource: Resource) -> Resource:
	Settings.file.visuals.resource_packs.push_front("**Character**")
	var whatever = c.execute_next([resource])
	
	while Settings.file.visuals.resource_packs.has("**Character**"):
		Settings.file.visuals.resource_packs.erase("**Character**")
	return whatever
	
func get_resource_path(c: ModLoaderHookChain, resource_path := "") -> String:
	var test = resource_path.replace("res://Assets", Global.config_path.path_join("custom_characters/" + Player.CHARACTERS[Global.player_characters[0]] + "/Assets"))
	if (test.contains("custom_characters")):
		test = test.replace(Global.config_path.path_join("custom_characters"), Global.config_path.path_join("custom_characters/" + Player.CHARACTERS[Global.player_characters[0]] + "/Assets/Sprites/Players/CustomCharacters"))
	if FileAccess.file_exists(test):
		return test
	return c.execute_next([resource_path])

static func get_resource_pack_from_path(c: ModLoaderHookChain, path := "") -> String:
	if !path.contains("custom_characters/" + Player.CHARACTERS[Global.player_characters[0]]):
		return c.execute_next([path])
	var resource_pack := ""
	var split_1 = path.split("custom_characters/" + Player.CHARACTERS[Global.player_characters[0]])
	resource_pack = split_1[1].get_slice("/", 1)
	return resource_pack
