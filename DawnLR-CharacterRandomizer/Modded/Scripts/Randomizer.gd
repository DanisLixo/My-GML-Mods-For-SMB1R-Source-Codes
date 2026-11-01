extends Object

var RandomizerSettings = Settings.get_meta("RandomizerMod") 

## Delete duplicates in an array.
func remove_duplicates(array: Array) -> Array:
	var seen = {}
	var result = []
	for value in array:
		if not seen.has(value):
			seen[value] = true
			result.append(value)
	return result

## This doesn't affect character selection, only when you're still playing.
func refresh_char_list(adjust: bool = false) -> void:
	if (!RandomizerSettings.file.options.enabled):
		return
	
	RandomizerSettings.charList = Player.CHARACTERS.duplicate()
	if (adjust):
		if (RandomizerSettings.file.options.excluded_characters != []):
			RandomizerSettings.file.options.excluded_characters = remove_duplicates(RandomizerSettings.file.options.excluded_characters)
			
			for i in RandomizerSettings.file.options.excluded_characters:
				if (RandomizerSettings.charList.has(i)):
					RandomizerSettings.charList.erase(i)
			
		if (RandomizerSettings.file.options.use_user_character_list && RandomizerSettings.file.options.user_character_list != []):
			var newList = []
			for i in RandomizerSettings.file.options.user_character_list:
				if (RandomizerSettings.charList.has(i)):
					newList.append(i)
			
			RandomizerSettings.charList = newList.duplicate()
	
	if (RandomizerSettings.file.options.one_shot_characters):
		refresh_used_chars()

## Reset the used characters list.
func refresh_used_chars() -> void:
	if (RandomizerSettings.charUsedList.size() != RandomizerSettings.charList.size()):
		RandomizerSettings.charUsedList.clear()
		for i in RandomizerSettings.charList.size():
			RandomizerSettings.charUsedList.append(false)
	
	if (RandomizerSettings.charUsedList.find(false) == -1):
		for i in RandomizerSettings.charList.size():
			RandomizerSettings.charUsedList[i] = (false)

func set_new_character(player_id := 0) -> int:
	if (!RandomizerSettings.file.options.enabled):
		return Global.player_characters[player_id]
	
	if (Global.player_characters[player_id] == -1):
		return Global.player_characters[player_id]
	
	refresh_char_list(true)
	
	var newCharID
	
	if (RandomizerSettings.file.options.not_random):
		if (RandomizerSettings.file.options.use_user_character_list):
			newCharID = RandomizerSettings.charList[RandomizerSettings.user_list_not_random_idx]
			RandomizerSettings.user_list_not_random_idx += 1
		else:
			newCharID = RandomizerSettings.charList[Global.player_characters[player_id] + 1]
		
		if (RandomizerSettings.charList.find(newCharID) > RandomizerSettings.charList.size() - 1):
			newCharID = RandomizerSettings.charList[0]
	else:
		newCharID = RandomizerSettings.charList[randi_range(0, RandomizerSettings.charList.size() - 1)]
	
	var tries := 0
	if (RandomizerSettings.file.options.one_shot_characters && RandomizerSettings.charUsedList.size() != 0):
		while (RandomizerSettings.charUsedList[newCharID] == true || newCharID == Global.player_characters[player_id]):
			newCharID = RandomizerSettings.charList[randi_range(0, RandomizerSettings.charList.size() - 1)]
			tries += 1
			
			if (tries > 5):
				break
	
		RandomizerSettings.charUsedList[RandomizerSettings.charList.find(newCharID)] = true

	if (RandomizerSettings.charList.find(newCharID) == -1):
		printerr(error_string(ERR_UNAVAILABLE) + " - NO CHARACTERS AVAILABLE")
	
	return Player.CHARACTERS.find(newCharID)

func start_randomizing(reset_players := false) -> void:
	if (!RandomizerSettings.file.options.enabled):
		return
	for i in Global.player_characters.size():
		if (i > 0 && RandomizerSettings.file.options.randomize_player_one_only):
			continue
		Global.player_characters[i] = set_new_character(i)
		
	if (reset_players):
		var p = Global.get_tree().get_nodes_in_group("Players")
		for j in p:
			if (is_instance_valid(j)):
				force_player_soft_restart(j)
	
	if (RandomizerSettings.firstLoad):
		RandomizerSettings.firstLoad = false
	
	Global.set_meta("player_characters_backup", Global.player_characters.duplicate())

func force_player_soft_restart(player: Player) -> void:
	var arr: Array = get_all_children(player)
	for n in arr:
		if (n.has_method("_ready")):
			n._ready()
		
func get_all_children(in_node, arr := []):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child, arr)
	return arr
