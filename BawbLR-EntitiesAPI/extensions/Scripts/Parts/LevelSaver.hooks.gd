extends Object

func save_level(c: ModLoaderHookChain ,level_name := "Unnamed Level", level_author := "You", level_desc := "No Desc", difficulty := 0) -> Dictionary:
	var level_file = c.execute_next([level_name, level_author, level_desc, difficulty])
	
	if LevelEditor.level_file.has("Mods"):
		level_file["Mods"] = LevelEditor.level_file["Mods"]
	return level_file
