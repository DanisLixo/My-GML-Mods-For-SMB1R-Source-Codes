extends Object

func transition_to_scene(c: ModLoaderHookChain, scene_path = "") -> void:
	var savedList: Array = c.reference_object.get_meta("savedList", ["nMQt5f"])
	if (scene_path is String 
	&& (scene_path.contains("TitleScreen") 
	|| scene_path.contains("CustomLevelMenu")
	|| scene_path.contains("BooRace")) && savedList[0] != "nMQt5f"):
		Settings.file.visuals.resource_packs = savedList.duplicate()
		c.reference_object.set_meta("savedList", ["nMQt5f"])
	
	c.execute_next_async([scene_path])
