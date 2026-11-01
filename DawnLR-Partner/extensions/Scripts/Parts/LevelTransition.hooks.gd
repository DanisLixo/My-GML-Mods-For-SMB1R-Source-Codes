extends Object 

func _ready(c: ModLoaderHookChain) -> void:
	if (Settings.file.partners.amount == 0 
	|| Global.current_game_mode == Global.GameMode.MARATHON
	|| Global.current_game_mode == Global.GameMode.MARATHON_PRACTICE):
		c.execute_next_async()
		return
	
	var partners_list = load("res://mods-unpacked/DawnLR-Partner/Modded/UI/LevelTransitionPartnersList.tscn").instantiate()
	c.reference_object.get_node("BG").add_child(partners_list)
	
	c.execute_next_async()
