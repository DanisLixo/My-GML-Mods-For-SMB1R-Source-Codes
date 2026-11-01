extends Node

var partners_global = load("res://mods-unpacked/DawnLR-Partner/PartnersHandler.gd").new()
const MOD_DIR := "DawnLR-Partner"
const LOG_NAME := "DawnLR-Partner:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

var my_settings := {
	"partners": {
		"cpu_permanent_size": 0, 
		"power_up_exclusivity": 0, 
		"cpu_muted": 0,
		"apply_physics": 1, 
		"respawn_time": 5.0,
		
		"copy_permanent_size": 0, 
		"copy_muted": 0,
		
		"unlock_limit": 0,
		"follow_mode": 0,
		"amount": 3,
		"characters": [0, 1, 2, 3],
		
		"enemy_spawn_delay": 5.0,
		"behavior": [0, 0, 0, 0]
	}
}

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
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Entities/Player.gd", extensions_dir_path.path_join("Scripts/Classes/Entities/Player.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/PlayerSprite.gd", extensions_dir_path.path_join("Scripts/Parts/PlayerSprite.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/FlagPole.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/FlagPole.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/LevelExit.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/LevelExit.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/Normal.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/Normal.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/UI/AudioAdjuster.gd", extensions_dir_path.path_join("Scripts/UI/AudioAdjuster.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/CoinHeaven.gd", extensions_dir_path.path_join("Scripts/Classes/CoinHeaven.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Entities/Objects/PitWarp.gd", extensions_dir_path.path_join("Scripts/Classes/Entities/Objects/PitWarp.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Entities/PipeArea.gd", extensions_dir_path.path_join("Scripts/Classes/Entities/PipeArea.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/PipeCutscene.gd", extensions_dir_path.path_join("Scripts/Parts/PipeCutscene.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Singletons/Global.gd", extensions_dir_path.path_join("Scripts/Classes/Singletons/Global.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Editor/LevelEditor.gd", extensions_dir_path.path_join("Scripts/Classes/Editor/LevelEditor.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/CameraHandler.gd", extensions_dir_path.path_join("Scripts/Parts/CameraHandler.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/PickAPathTeleport.gd", extensions_dir_path.path_join("Scripts/Parts/PickAPathTeleport.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Singletons/AudioManager.gd", extensions_dir_path.path_join("Scripts/Classes/Singletons/AudioManager.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/LevelTransition.gd", extensions_dir_path.path_join("Scripts/Parts/LevelTransition.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/Climb.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/Climb.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Entities/Items/Vine.gd", extensions_dir_path.path_join("Scripts/Classes/Entities/Items/Vine.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/UI/SettingsMenu.gd", extensions_dir_path.path_join("Scripts/UI/SettingsMenu.hooks.gd"))

func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")

func _enter_tree() -> void:
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Singletons/SettingsManager.gd", extensions_dir_path.path_join("Scripts/Classes/Singletons/SettingsManager.hooks.gd"))

func _ready() -> void:
	add_child(partners_global)
