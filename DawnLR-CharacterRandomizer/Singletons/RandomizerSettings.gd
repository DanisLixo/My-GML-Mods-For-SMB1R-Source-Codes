extends Node

var charList := []
var firstLoad = true
var charUsedList := []
var user_list_not_random_idx := 0

var CONFIG_FILE = Global.config_path.path_join("randomizer.cfg")
var file := {
	"options": {
		"enabled": true,
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

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	name = "RandomizerSettings"
	Settings.set_meta("RandomizerMod", self)

func _ready() -> void:
	load("res://Scripts/UI/CharacterSelect.gd").new().get_custom_characters()
	load_settings()

func _process(_delta: float) -> void:
	if (Global.multibind_action_just_pressed("ui_toggle_randomizer")):
		file.options.enabled = !file.options.enabled
		save_settings()
		
		if (file.options.enabled):
			Global.log_comment("You activated Character Randomizing!")
		else:
			Global.log_comment("You deactivated Character Randomizing!")
	
	if (charList.size() != Player.CHARACTERS.size()):
		var randomizer = load("res://mods-unpacked/DawnLR-CharacterRandomizer/Modded/Scripts/Randomizer.gd").new()
		
		randomizer.refresh_char_list()
