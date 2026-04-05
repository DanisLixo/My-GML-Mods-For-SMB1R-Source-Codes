extends Node

var CONFIG_FILE = Global.config_path.path_join("partner.cfg")
var file := {
	"cpu_options": {
		"permanent_size": 0, 
		"power_up_exclusivity": 0, 
		"muted": 0,
		"apply_physics": 1, 
		"respawn_time": 5.0
	},
	"copy_options": {
		"permanent_size": 0, 
		"muted": 0
	},
	"selector": {
		"unlock_limit": 0,
		"follow_mode": 0,
		"amount": 3,
		"characters": [0, 1, 2, 3],
		
		"enemy_spawn_delay": 5.0,
		"behavior": [0, 0, 0, 0]
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
			
func create_file() -> void:
	var cfg_file = ConfigFile.new()
	for section in file.keys():
		for key in file[section].keys():
			cfg_file.set_value(section, key, file[section][key])
	cfg_file.save(CONFIG_FILE)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	load_settings()
	
	if (file.selector.characters.size() < 4):
		file.selector.characters.resize(4)
		save_settings()
	if (file.selector.characters.size() - 1 != file.selector.amount && file.selector.characters.size() > 4):
		file.selector.amount = file.selector.characters.size() - 1
		save_settings()
	if (file.selector.behavior.size() != file.selector.characters.size()):
		file.selector.behavior.resize(file.selector.amount + 1)
		for i in file.selector.behavior.size():
			if (file.selector.behavior[i] == null):
				file.selector.behavior[i] = 0
		save_settings()
	print(str(file.selector.behavior))
	
	await get_tree().process_frame
	
	for i in file.selector.characters.size():
		file.selector.characters[i] = clampi(file.selector.characters[i], -1, 3)
	print(str(file.selector.characters))
		
	Global.player_characters = file.selector.characters
	print(str(Global.player_characters))
