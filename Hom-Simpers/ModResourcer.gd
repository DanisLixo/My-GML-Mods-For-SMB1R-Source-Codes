extends Object

func convert_custom_objects_path(resource_path := "", short := false) -> String:
	if (!resource_path.contains("mods-unpacked") && !resource_path.contains("custom_objects-unpacked")):
		return resource_path
	
	var short_path := "res://Assets/"
	var final_path := "res://Assets/CustomObjects"
	
	var record_from_here := 0
	for subdir in Array(resource_path.split("/")):
		if (record_from_here >= 3 && subdir.to_lower() != "assets"):
			short_path = short_path.path_join(subdir)
		if (record_from_here >= 1):
			final_path = final_path.path_join(subdir)
			record_from_here += 1
		if (record_from_here < 1):
			if (subdir == "custom_objects-unpacked"):
				record_from_here = 1
			elif (subdir == "mods-unpacked"):
				record_from_here = 1
	
	if (short):
		return short_path
	
	return final_path
