extends Object

func _enter_tree(c: ModLoaderHookChain) -> void:
	load("res://mods-unpacked/DawnLR-CharacterRandomizer/Singletons/InputMapInjection.gd").new().start()
	Settings.SETTINGS_DIR = Global.config_path.path_join("settings_for_mods.cfg")
	
	c.execute_next_async()
