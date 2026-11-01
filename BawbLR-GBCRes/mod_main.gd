extends Node


const MOD_DIR := "BawbLR-GBCRes"
const LOG_NAME := "BawbLR-GBCRes:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

@onready var CONFIG_FILE = Global.config_path.path_join("GBCRes.cfg")
var file := {"video": {"enabled": false}}

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)
	# Add extensions
	install_script_extensions()
	install_script_hook_files()

	# Add translations
	add_translations()


func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")


func install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/CameraHandler.gd", extensions_dir_path.path_join("Scripts/Parts/CameraHandler.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/UI/SettingsMenu.gd", extensions_dir_path.path_join("Scripts/UI/SettingsMenu.hooks.gd"))



func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")

signal screen_size_changed()

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

func _ready() -> void:
	Settings.set_meta("GBCResMod", self)
	
	load_settings()
	
	Global.transition_finished.connect(crunch_screen)
	screen_size_changed.connect(crunch_screen)

var window_changed := false
var old_scren_size := Vector2i.ZERO
func _process(_delta: float) -> void:
	if (old_scren_size != get_window().content_scale_size):
		screen_size_changed.emit()
		
		old_scren_size = get_window().content_scale_size

const RESOLUTIONS := [Vector2(160, 144), Vector2(192, 144), Vector2(256, 144), Vector2(160, 144)]

func crunch_screen() -> void:
	var player: Player = get_tree().get_first_node_in_group("Players")
	var current_is_level := player && get_tree().current_scene is Level && get_tree().current_scene is not TitleScreen
	if (!file.video.enabled): 
		current_is_level = false
	var scaled = file.video.enabled && current_is_level
	
	var game_hud: GameHUD = Global.get_node("GameHUD")
	var buffers := ["Main/Buffer", "Main/Buffer2", "Main/Buffer3", "Main/Buffer4", "Main/Buffer5"]
	
	if (current_is_level || window_changed):
		for i in buffers:
			game_hud.get_node(i).visible = !scaled || Settings.file.video.size == 2
			print(game_hud.get_node(i).visible)
		var main_hud: HBoxContainer = game_hud.get_node("Main")
		var modern_hud: Control = game_hud.get_node("ModernHUD")
		main_hud.alignment = BoxContainer.ALIGNMENT_CENTER if scaled else BoxContainer.ALIGNMENT_BEGIN
		main_hud.custom_minimum_size.y = 24.0 if scaled else 32.0
		modern_hud.custom_minimum_size.x = 256.0 if !scaled else 144.0
		main_hud.position.y = -8.0 if scaled else 0.0
	
	if (current_is_level):
		get_window().content_scale_size = RESOLUTIONS[Settings.file.video.size]
		
		await get_tree().process_frame
		if (!player.camera.is_current()):
			player.camera.make_current()
			
		window_changed = true
	elif (window_changed):
		get_window().content_scale_size = Global.RESOLUTIONS[Settings.file.video.size]
		
		window_changed = false
