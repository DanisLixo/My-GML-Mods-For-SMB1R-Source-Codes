extends Node

const MOD_DIR := "DawnLR-DirtBlockObj"
const LOG_NAME := "DawnLR-DirtBlockObj:Main"

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
	ModLoaderMod.install_script_hooks("res://Scenes/Prefabs/Autoload/NewLevelBuilder.gd", extensions_dir_path.path_join("Scenes/Prefabs/Autoload/NewLevelBuilder.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Editor/LevelEditor.gd", extensions_dir_path.path_join("Scripts/Classes/Editor/LevelEditor.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/LevelSaver.gd", extensions_dir_path.path_join("Scripts/Parts/LevelSaver.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/EntityIdMapper.gd", extensions_dir_path.path_join("Scripts/Parts/EntityIdMapper.hooks.gd"))


func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")


func _ready() -> void:
	pass
