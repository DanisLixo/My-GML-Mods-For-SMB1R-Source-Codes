extends Node


const MOD_DIR := "DawnLR-ResourcePackRandomizer"
const LOG_NAME := "DawnLR-ResourcePackRandomizer:Main"

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
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Singletons/Global.gd", extensions_dir_path.path_join("Scripts/Classes/Singletons/Global.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/LevelTransition.gd", extensions_dir_path.path_join("Scripts/Parts/LevelTransition.hooks.gd"))



func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")


func _ready() -> void:
	pass
