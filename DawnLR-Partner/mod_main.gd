extends Node


const MOD_DIR := "DawnLR-Partner"
const LOG_NAME := "DawnLR-Partner:Main"

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
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Entities/Player.gd", extensions_dir_path.path_join("Scripts/Classes/Entities/Player.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/PlayerSprite.gd", extensions_dir_path.path_join("Scripts/Parts/PlayerSprite.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/FlagPole.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/FlagPole.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/LevelExit.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/LevelExit.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/Normal.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/Normal.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/UI/AudioAdjuster.gd", extensions_dir_path.path_join("Scripts/UI/AudioAdjuster.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/TitleScreen.gd", extensions_dir_path.path_join("Scripts/Parts/TitleScreen.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/UI/CustomLevelMenu.gd", extensions_dir_path.path_join("Scripts/UI/CustomLevelMenu.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/UI/BooRaceMenu.gd", extensions_dir_path.path_join("Scripts/UI/BooRaceMenu.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/CoinHeaven.gd", extensions_dir_path.path_join("Scripts/Classes/CoinHeaven.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Entities/Objects/PitWarp.gd", extensions_dir_path.path_join("Scripts/Classes/Entities/Objects/PitWarp.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Entities/PipeArea.gd", extensions_dir_path.path_join("Scripts/Classes/Entities/PipeArea.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/PipeCutscene.gd", extensions_dir_path.path_join("Scripts/Parts/PipeCutscene.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Singletons/Global.gd", extensions_dir_path.path_join("Scripts/Classes/Singletons/Global.hooks.gd"))
	
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Editor/LevelEditor.gd", extensions_dir_path.path_join("Scripts/Classes/Editor/LevelEditor.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/CameraHandler.gd", extensions_dir_path.path_join("Scripts/Parts/CameraHandler.hooks.gd"))

func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	var partnerSaveNode = load(mod_dir_path + "/Scripts/Classes/Singletons/PartnerSettingsManager.gd").new()
	partnerSaveNode.name = "PartnerSettingsManager"
	add_child(partnerSaveNode)
