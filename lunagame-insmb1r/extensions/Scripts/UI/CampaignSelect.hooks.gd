extends Object

func get_level_packs(c: ModLoaderHookChain) -> void:
	var sel = c.reference_object
	
	c.execute_next()
	
	var i = "LunaGame"
	var path := "res://mods-unpacked/lunagame-insmb1r/LevelPackFolder/"
	var json = JSON.parse_string(FileAccess.open(path.path_join("pack_info.json"), FileAccess.READ).get_as_text())
	
	Level.WORLD_COUNTS[i] = json.number_of_worlds
	
	Global.custom_campaign_jsons["LunaGame"] = json
	Global.custom_campaigns.push_front(i)
	sel.campaign.insert(5, i)
	sel.campaign_icons.insert(5, load("res://mods-unpacked/lunagame-insmb1r/LevelPackFolder/icon.png"))
	
	var title: Label = sel.get_node("PanelContainer/MarginContainer/VBoxContainer/CampaignNames/Custom").duplicate()
	title.text = json.name + "\nBy " + json.author
	title.add_theme_color_override("font_shadow_color", Color(json.text_colour))
	
	sel.get_node("PanelContainer/MarginContainer/VBoxContainer/CampaignNames").add_child(title)
	sel.get_node("PanelContainer/MarginContainer/VBoxContainer/CampaignNames").move_child(title, 5)
