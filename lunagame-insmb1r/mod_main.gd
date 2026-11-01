extends Node


const MOD_DIR := "lunagame-insmb1r"
const LOG_NAME := "lunagame-insmb1r:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""


func _init() -> void:
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
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/TitleScreen.gd", extensions_dir_path.path_join("Scripts/Parts/TitleScreen.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/UI/CampaignSelect.gd", extensions_dir_path.path_join("Scripts/UI/CampaignSelect.hooks.gd"))

func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")


func _ready() -> void:
	var global_luna = load("res://mods-unpacked/lunagame-insmb1r/LunaGameFiles/Scripts/global.gd").new()
	global_luna.name = "LunaGlobal"
	global_luna.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(global_luna)
