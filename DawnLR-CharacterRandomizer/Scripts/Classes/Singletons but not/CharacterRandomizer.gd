extends Node

static var charList := []
var firstLoad = true
var charUsedList := []

var active = true

var CONFIG_FILE = Global.config_path.path_join("randomizer.cfg")
var file := {
	"options": {
		"alwaysShowInitialWarning": 2,
		"randomize_on_start": false, # Randomize even when first getting a character.
		"every_transition": true, # Randomizing works in EVERY transition.
		"one_shot_characters": false, # Characters appear once until everyone appears.
		"not_random": false, # Sets a looping character picking instead of actual random.
		"use_user_character_list": false, # Use characters specified by the user instead of everyone.
		"randomize_player_one_only": false, # Use characters specified by the user instead of everyone.
		"user_character_list": [], # List for characters you want to use.
		"excluded_characters": [] # List of characters you don't want to appear, only works if not using user list.
	}
}

func save_settings() -> void:
	active = false
	var cfg_file = ConfigFile.new()
	for section in file.keys():
		for key in file[section].keys():
			cfg_file.set_value(section, key, file[section][key])
	cfg_file.save(CONFIG_FILE)

## Loads your settings, if file doesn't exist, calls 'create_file()'.
func load_settings() -> void:
	if FileAccess.file_exists(CONFIG_FILE) == false:
		create_file()
	var cfg_file = ConfigFile.new()
	cfg_file.load(CONFIG_FILE)
	for section in cfg_file.get_sections():
		for key in cfg_file.get_section_keys(section):
			file[section][key] = cfg_file.get_value(section, key)

## Creates the file and apply the default settings.
func create_file() -> void:
	var cfg_file = ConfigFile.new()
	for section in file.keys():
		for key in file[section].keys():
			cfg_file.set_value(section, key, file[section][key])
	cfg_file.save(CONFIG_FILE)

## Delete duplicates in an array.
func remove_duplicates(array: Array) -> Array:
	var seen = {}
	var result = []
	for value in array:
		if not seen.has(value):
			seen[value] = true
			result.append(value)
	return result
	
func refresh_inputs() -> void:
	var actions = ["toggle_randomizer", "open_cfg_randomizer"]
	var inputs = [InputEventKey.new(), InputEventKey.new()]
	inputs[0].keycode = KEY_F6
	inputs[1].keycode = KEY_F7
	
	for i in actions.size():
		InputMap.add_action(actions[i])
		InputMap.action_add_event(actions[i], inputs[i])

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	for i in Settings.file.game.characters.size():
		Settings.file.game.characters[i] = clampi(Settings.file.game.characters[i], -1, 3)
	load_settings()
	
	refresh_char_list()
	
	refresh_inputs()

func _process(_delta: float) -> void:
	if (!InputMap.has_action("toggle_randomizer")):
		refresh_inputs()
	
	if (Input.is_action_just_pressed("toggle_randomizer")):
		active = !active
		if (active):
			load_settings()
			Global.log_comment("You activated Character Randomizing!")
		else:
			Global.log_comment("You deactivated Character Randomizing!")
	if (Input.is_action_just_pressed("open_cfg_randomizer")):
		if FileAccess.file_exists(CONFIG_FILE):
			OS.shell_open(ProjectSettings.globalize_path(CONFIG_FILE))
	
	if (charList.size() != Player.CHARACTERS.size()):
		refresh_char_list()

## This doesn't affect character selection, only when you're still playing.
func refresh_char_list(adjust: bool = false) -> void:
	if (!active):
		return
	
	if (adjust):
		if (file.options.excluded_characters != []):
			file.options.excluded_characters = remove_duplicates(file.options.excluded_characters)
			
			for i in file.options.excluded_characters:
				if (!["Mario", "Luigi", "Toad", "Toadette"].has(i) && Player.CHARACTERS.has(i)):
					Player.CHARACTERS.erase(i)
					
			
		if (file.options.use_user_character_list && file.options.user_character_list != []):
			var newList = ["Mario", "Luigi", "Toad", "Toadette"]
			for i in file.options.user_character_list:
				if (Player.CHARACTERS.has(i)):
					newList.append(i)
			
			newList = remove_duplicates(newList)
			Player.CHARACTERS = newList.duplicate()
	
	charList = Player.CHARACTERS.duplicate()
	
	if (file.options.one_shot_characters):
		refresh_used_chars()

## Reset the used characters list.
func refresh_used_chars() -> void:
	if (charUsedList.size() != charList.size()):
		charUsedList.clear()
		for i in charList.size():
			charUsedList.append(false)
	
	if (charUsedList.find(false) == -1):
		for i in charList.size():
			charUsedList[i] = (false)

func set_new_character(player_id := 0) -> int:
	if (!active || (firstLoad && !file.options.randomize_on_start)):
		return Global.player_characters[player_id]
	
	if ((player_id == -1)):
		return Global.player_characters[player_id]
	
	print(str(firstLoad)) 
	refresh_char_list(true)
	
	var newCharID
	
	if (file.options.not_random):
		newCharID = Global.player_characters[player_id] + 1
		
		if (newCharID > charList.size() - 1):
			newCharID = 0
	else:
		newCharID = randi_range(0, charList.size() - 1)
	
	var tries := 0
	if (file.options.one_shot_characters && charUsedList.size() != 0):
		while (charUsedList[newCharID] == true || newCharID == Global.player_characters[player_id]):
			newCharID = randi_range(0, charList.size() - 1)
			tries += 1
			
			if (tries > 5):
				break
	
		charUsedList[newCharID] = true

	if (newCharID == -1):
		print(error_string(ERR_UNAVAILABLE) + " - NO CHARACTERS AVAILABLE")
	
	return newCharID

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
