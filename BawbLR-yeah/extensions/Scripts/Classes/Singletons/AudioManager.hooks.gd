extends Object

func generate_interactive_stream(c:ModLoaderHookChain, bgm_file := {}) -> AudioStreamInteractive:
	if (!bgm_file.Normal.source.contains("mods-unpacked")):
		return c.execute_next([bgm_file])
	
	return generate_modded(bgm_file)

func generate_modded(bgm_file := {}) -> AudioStreamInteractive:
	var stream = AudioManager.MUSIC_BASE.duplicate()
	var normal_path := ""
	var normal_loop := -1.0
	
	var hurry_path := ""
	var hurry_loop := -1.0
	
	# Default stuff, in case you just want a simple loop.
	if (bgm_file.has("source")):
		normal_path = ResourceSetter.get_pure_resource_path(bgm_file["source"])
		hurry_path = ResourceSetter.get_pure_resource_path(bgm_file["source"])
	if (bgm_file.has("loop")):
		normal_loop = bgm_file["loop"]
		hurry_loop = bgm_file["loop"]
	
	if (bgm_file.has("Normal")):
		if (bgm_file["Normal"].has("source")):
			normal_path = ResourceSetter.get_pure_resource_path(bgm_file["Normal"]["source"])
		else:
			Global.log_error("Normal variation source for current track was not found.")
		if (bgm_file["Normal"].has("loop")):
			normal_loop = bgm_file["Normal"]["loop"]
		else:
			Global.log_warning("Normal variation looping for current track was not found.")
	if (bgm_file.has("Hurry")):
		if (bgm_file["Hurry"].has("source")):
			hurry_path = ResourceSetter.get_pure_resource_path(bgm_file["Hurry"]["source"])
		else:
			Global.log_error("Hurry variation source for current track was not found.")
		if (bgm_file["Hurry"].has("loop")):
			hurry_loop = bgm_file["Hurry"]["loop"]
		else:
			Global.log_warning("Hurry variation looping for current track was not found.")
	stream.set_clip_stream(0, AudioManager.import_stream(normal_path, normal_loop))
	stream.set_clip_stream(1, AudioManager.import_stream(hurry_path, hurry_loop))
	return stream
