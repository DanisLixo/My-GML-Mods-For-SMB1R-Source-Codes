extends Object

func _enter_tree(c: ModLoaderHookChain) -> void:
	l_copy_settings()
	
	load("res://mods-unpacked/DawnLR-Partner/Singletons/InputMapInjection.gd").new().start()
	Settings.SETTINGS_DIR = Global.config_path.path_join("settings_for_mods.cfg")
	
	l_inject_my_settings()
	
	c.execute_next_async()

func l_copy_settings() -> void:
	var new_file := Global.config_path.path_join("settings_for_mods.cfg")
	
	if (!FileAccess.file_exists(new_file)):
		l_copy_file(Settings.SETTINGS_DIR, new_file)

func l_inject_my_settings() -> void:
	Global.merge_dict(Settings.file, Global.get_node("/root/ModLoader/DawnLR-Partner").my_settings)

func l_copy_file(source_path, new_path) -> void:
	var source := FileAccess.open(source_path, FileAccess.READ)
	
	var pasted := FileAccess.open(new_path, FileAccess.WRITE)
	var success := pasted.store_buffer(source.get_buffer(source.get_length()))
	
	pasted.close()
	source.close()
	
	if (success):
		Global.log_comment("YOUR SETTINGS FILE GOT COPY! MODS NOW CAN STORE SETTINGS IN FILE \"settings_for_mods.cfg\"")

func load_settings(c: ModLoaderHookChain) -> void:
	if FileAccess.file_exists(Settings.SETTINGS_DIR) == false:
		Settings.save_settings()
	var cfg_file = ConfigFile.new()
	cfg_file.load(Settings.SETTINGS_DIR)
	for section in cfg_file.get_sections():
		for key in cfg_file.get_section_keys(section):
			Settings.file.get_or_add(section, {}).get_or_add(key, cfg_file.get_value(section, key))
			print([section, key, cfg_file.get_value(section, key)])
			print(Settings.file[section][key])
	Settings.fix_broken_settings()
