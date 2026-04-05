extends Node

const MOVESET_PLUS_SFX_LIBRARY = {
	"spin_jump" : ("res://Assets/Audio/SFX/MovesetPlus/SpinJump.wav"),
}

const MOD_DIR := "DawnLR-MovesetPlus"
const LOG_NAME := "DawnLR-MovesetPlus:Main"

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
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Components/EnemyPlayerDetection.gd", extensions_dir_path.path_join("Scripts/Classes/Components/EnemyPlayerDetection.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Entities/Player.gd", extensions_dir_path.path_join("Scripts/Classes/Entities/Player.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/Normal.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/Normal.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/FlagPole.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/FlagPole.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/Pipe.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/Pipe.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/Climb.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/Climb.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/BetterAnimatedSprite.gd", extensions_dir_path.path_join("Scripts/Parts/BetterAnimatedSprite.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/PlayerSprite.gd", extensions_dir_path.path_join("Scripts/Parts/PlayerSprite.hooks.gd"))

	ModLoaderMod.install_script_hooks("res://Scripts/UI/BooRaceMenu.gd", extensions_dir_path.path_join("Scripts/UI/BooRaceMenu.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/UI/CustomLevelMenu.gd", extensions_dir_path.path_join("Scripts/UI/CustomLevelMenu.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/TitleScreen.gd", extensions_dir_path.path_join("Scripts/Parts/TitleScreen.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Components/ResourceGetter.gd", extensions_dir_path.path_join("Scripts/Classes/Components/ResourceGetter.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Components/ResourceSetter.gd", extensions_dir_path.path_join("Scripts/Classes/Components/ResourceSetter.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Components/ResourceSetterNew.gd", extensions_dir_path.path_join("Scripts/Classes/Components/ResourceSetterNew.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Singletons/AudioManager.gd", extensions_dir_path.path_join("Scripts/Classes/Singletons/AudioManager.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/Disclaimer.gd", extensions_dir_path.path_join("Scripts/Parts/Disclaimer.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Singletons/Global.gd", extensions_dir_path.path_join("Scripts/Classes/Singletons/Global.hooks.gd"))

func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")


func _ready() -> void:
	pass
