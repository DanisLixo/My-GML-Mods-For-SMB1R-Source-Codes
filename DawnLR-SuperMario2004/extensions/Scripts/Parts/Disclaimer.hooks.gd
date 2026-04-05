extends Object

func go_to_menu(c: ModLoaderHookChain) -> void:
	ResourceGenerator.updating = true
	Global.transition_to_scene("res://mods-unpacked/DawnLR-SuperMario2004/Scenes/SourceEngineLogo.tscn")
