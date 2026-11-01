extends Object

func _enter_tree(chain):
	var refobj = chain.reference_object
	var mod_main = refobj.get_tree().root.get_node("ModLoader/DeGezondeRoker-TooManyPowerUps")
	
	var config
	var resource_pack := "TooManyPowerups"
	if FileAccess.file_exists("user://resource_packs/" + resource_pack + "/config.json"):
		config = JSON.parse_string(FileAccess.open("user://resource_packs/" + resource_pack + "/config.json", FileAccess.READ).get_as_text())
		if config == null:
			Global.log_error("Error parsing Config File! (" + resource_pack + ")")
			config = {}
	if config != null:
		mod_main.world_powerups[0] = str(config["options"]["W1 Power-Up"])
		mod_main.world_powerups[1] = str(config["options"]["W2 Power-Up"])
		mod_main.world_powerups[2] = str(config["options"]["W3 Power-Up"])
		mod_main.world_powerups[3] = str(config["options"]["W4 Power-Up"])
		mod_main.world_powerups[4] = str(config["options"]["W5 Power-Up"])
		mod_main.world_powerups[5] = str(config["options"]["W6 Power-Up"])
		mod_main.world_powerups[6] = str(config["options"]["W7 Power-Up"])
		mod_main.world_powerups[7] = str(config["options"]["W8 Power-Up"])
		
		mod_main.world_distribution[0] = str(config["options"]["W1 Placement"])
		mod_main.world_distribution[1] = str(config["options"]["W2 Placement"])
		mod_main.world_distribution[2] = str(config["options"]["W3 Placement"])
		mod_main.world_distribution[3] = str(config["options"]["W4 Placement"])
		mod_main.world_distribution[4] = str(config["options"]["W5 Placement"])
		mod_main.world_distribution[5] = str(config["options"]["W6 Placement"])
		mod_main.world_distribution[6] = str(config["options"]["W7 Placement"])
		mod_main.world_distribution[7] = str(config["options"]["W8 Placement"])
		
#		mod_main.config_editorpowerup = str(config["options"]["Editor Power-Up"])
		mod_main.config_forcepowerup= int(config["options"]["Force"])
		
		if str(config["options"]["Skip Mushroom"]) == "Yes":
			mod_main.config_skipmushroom = true
		else:
			mod_main.config_skipmushroom = false
	
	chain.execute_next_async()
