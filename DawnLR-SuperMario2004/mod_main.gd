extends Node


const MOD_DIR := "DawnLR-SuperMario2004"
const LOG_NAME := "DawnLR-SuperMario2004:Main"

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
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Parts/EndFlagpole.gd"))



func install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/Disclaimer.gd", extensions_dir_path.path_join("Scripts/Parts/Disclaimer.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/LevelTransition.gd", extensions_dir_path.path_join("Scripts/Parts/LevelTransition.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Entities/Player.gd", extensions_dir_path.path_join("Scripts/Classes/Entities/Player.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/UI/StoryPause.gd", extensions_dir_path.path_join("Scripts/UI/StoryPause.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/CastleBridge.gd", extensions_dir_path.path_join("Scripts/Parts/CastleBridge.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/TitleScreen.gd", extensions_dir_path.path_join("Scripts/Parts/TitleScreen.hooks.gd"))



func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")


func _ready() -> void:
	var enviromentDestroyer = load("res://mods-unpacked/DawnLR-SuperMario2004/Scenes/WorldEnvironment.tscn").instantiate()
	enviromentDestroyer.name = "EnviromentDestroyer"
	add_child(enviromentDestroyer)
