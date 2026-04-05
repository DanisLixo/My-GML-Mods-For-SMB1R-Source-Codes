extends Object

enum INPUT {XDIR, YDIR, JUMP, RUN, ACTION}

func player_action_pressed(c: ModLoaderHookChain, action := "", player_id = 0) -> bool:
	if (player_id == 0): return c.execute_next([action, player_id])
	
	var inputter = find_player_node_with_id(c, player_id)
	var enumAction = action_to_enum(action)
	
	if (action.to_lower().contains("move")):
		if (action.to_lower().contains("up") || action.to_lower().contains("left")):
			return inputter.keyHold[enumAction] == -1
		else:
			return inputter.keyHold[enumAction] == 1
	
	return inputter.keyHold[enumAction]

func player_action_just_pressed(c: ModLoaderHookChain, action := "", player_id = 0) -> bool:
	if (player_id == 0): return c.execute_next([action, player_id])
	
	var inputter = find_player_node_with_id(c, player_id)
	var enumAction = action_to_enum(action)
	
	if (action.to_lower().contains("move")):
		if (action.to_lower().contains("up") || action.to_lower().contains("left")):
			return inputter.keyPress[enumAction] == -1
		else:
			return inputter.keyPress[enumAction] == 1
	
	return inputter.keyPress[enumAction]

func player_action_just_released(c: ModLoaderHookChain, action := "", player_id = 0) -> bool:
	if (player_id == 0): return c.execute_next([action, player_id])
	
	var inputter = find_player_node_with_id(c, player_id)
	var enumAction = action_to_enum(action)
	
	if (action.to_lower().contains("move")):
		if (action.to_lower().contains("up") || action.to_lower().contains("left")):
			return inputter.keyRelease[enumAction] == -1
		else:
			return inputter.keyRelease[enumAction] == 1
	
	return inputter.keyRelease[enumAction]

func find_player_node_with_id(c: ModLoaderHookChain, player_id := 0) -> Node:
	for player in c.reference_object.get_tree().get_nodes_in_group("Players"):
		if (player.player_id == player_id):
			return player.get_meta("PartnerMod")
	printerr("Partner Node not found for action detection, is there a gap between IDs?")
	return null

func action_to_enum(action = "") -> INPUT:
	action = action.to_lower()
	if (action.contains("move")):
		if (action.contains("up") || action.contains("down")):
			return INPUT.YDIR
		else:
			return INPUT.XDIR
	
	if (action.contains("jump")):
		return INPUT.JUMP
	if (action.contains("run")):
		return INPUT.RUN
	if (action.contains("action")):
		return INPUT.ACTION
	
	printerr("action: %s not found in INPUT enum, is something missing?" % action)
	return -1
