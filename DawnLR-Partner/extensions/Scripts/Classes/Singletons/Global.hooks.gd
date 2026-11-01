extends Object

var INPUT: Dictionary

func _ready(c: ModLoaderHookChain) -> void:
	c.execute_next()
	Global.set_meta("InputEnum", {
		"X": 0,
		"Y": 1,
		"JUMP": 2,
		"ACTION": 3,
		"RUN": 4
	})
	
	INPUT = Global.get_meta("InputEnum")

func player_action_pressed(c: ModLoaderHookChain, action := "", player_id = 0) -> bool:
	if (player_id == 0): return c.execute_next([action, player_id])
	
	var inputter = find_player_node_with_id(c, player_id).get_meta("input_handler")
	var enumAction = action_to_enum(action)
	
	if (action.to_lower().contains("move")):
		if (action.to_lower().contains("up") || action.to_lower().contains("left")):
			return inputter.actions[enumAction] == -1
		else:
			return inputter.actions[enumAction] == 1
	
	return inputter.actions[enumAction]

func player_action_just_pressed(c: ModLoaderHookChain, action := "", player_id = 0) -> bool:
	if (player_id == 0): return c.execute_next([action, player_id])
	
	var inputter = find_player_node_with_id(c, player_id).get_meta("input_handler")
	var enumAction = action_to_enum(action)
	
	if (action.to_lower().contains("move")):
		if (action.to_lower().contains("up") || action.to_lower().contains("left")):
			return inputter.actions[enumAction] == -2
		else:
			return inputter.actions[enumAction] == 2
	
	return inputter.actions[enumAction]

func player_action_just_released(c: ModLoaderHookChain, action := "", player_id = 0) -> bool:
	if (player_id == 0): return c.execute_next([action, player_id])
	
	var inputter = find_player_node_with_id(c, player_id).get_meta("input_handler")
	var enumAction = action_to_enum(action)
	
	if (action.to_lower().contains("move")):
		if (action.to_lower().contains("up") || action.to_lower().contains("left")):
			return inputter.actions[enumAction] == -3
		else:
			return inputter.actions[enumAction] == 3
	
	return inputter.actions[enumAction]

func find_player_node_with_id(c: ModLoaderHookChain, player_id := 0) -> Node:
	for player in c.reference_object.get_tree().get_nodes_in_group("Players"):
		if (player.player_id == player_id):
			return player
	printerr("Partner Node not found for action detection, is there a gap between IDs?")
	return null

func action_to_enum(action = "") -> int:
	action = action.to_lower()
	if (action.contains("move")):
		if (action.contains("up") || action.contains("down")):
			return INPUT.Y
		else:
			return INPUT.X
	
	if (action.contains("jump")):
		return INPUT.JUMP
	if (action.contains("run")):
		return INPUT.RUN
	if (action.contains("action")):
		return INPUT.ACTION
	
	printerr("action: %s not found in INPUT enum, is something missing?" % action)
	return -1
