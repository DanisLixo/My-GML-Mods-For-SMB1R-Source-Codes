extends Object

func open_custom_campaign(c: ModLoaderHookChain) -> void:
	c.execute_next()
	
	if (Global.current_campaign == "LunaGame"):
		
		var GlobalLuna = c.reference_object.get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")
		
		GlobalLuna.playing_luna = true
		Global.transition_to_scene("res://mods-unpacked/lunagame-insmb1r/LunaGameFiles/Scenes/main_menu.tscn")
