extends Node


const MOD_DIR := "DawnLR-CharacterDebugging"
const LOG_NAME := "DawnLR-CharacterDebugging:Main"

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
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Entities/Player.gd", extensions_dir_path.path_join("Scripts/Classes/Entities/Player.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/Normal.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/Normal.hooks.gd"))



func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")


func _ready() -> void:
	var toggleDebugScript = load("res://mods-unpacked/DawnLR-CharacterDebugging/Scripts/Parts/ToggleDebug.gd").new()
	toggleDebugScript.name = "CharacterDebug"
	
	add_child(toggleDebugScript)
