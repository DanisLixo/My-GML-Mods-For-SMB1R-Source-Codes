extends Node


const MOD_DIR := "BawbLR-EntitiesAPI"
const LOG_NAME := "BawbLR-EntitiesAPI:Main"

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
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Editor/LevelEditor.gd", extensions_dir_path.path_join("Scripts/Classes/Editor/LevelEditor.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Editor/EditorTileSelector.gd", extensions_dir_path.path_join("Scripts/Classes/Editor/EditorTileSelector.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/EntityIdMapper.gd", extensions_dir_path.path_join("Scripts/Parts/EntityIdMapper.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/LevelSaver.gd", extensions_dir_path.path_join("Scripts/Parts/LevelSaver.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Editor/EditorSelectorScroller.gd", extensions_dir_path.path_join("Scripts/Classes/Editor/EditorSelectorScroller.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scenes/Prefabs/Autoload/NewLevelBuilder.gd", extensions_dir_path.path_join("Scenes/Prefabs/Autoload/NewLevelBuilder.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Components/ResourceSetterNew.gd", extensions_dir_path.path_join("Scripts/Classes/Components/ResourceSetterNew.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Components/ResourceSetter.gd", extensions_dir_path.path_join("Scripts/Classes/Components/ResourceSetter.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Components/ResourceGetter.gd", extensions_dir_path.path_join("Scripts/Classes/Components/ResourceGetter.hooks.gd"))

func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")

func _ready() -> void:
	var objs_getter = load("res://mods-unpacked/BawbLR-EntitiesAPI/Scripts/Classes/Components/CustomObjectsGetter.gd").new()
	add_child(objs_getter)
	objs_getter.find_objects()

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("layer_up") && !Global.transitioning_scene):
		if (get_tree().current_scene is not LevelEditor):
			if (LevelEditor.level_file.has("Mods")):
				NewLevelBuilder.set_meta("custom_list", LevelEditor.level_file["Mods"])
			
			Global.current_game_mode = Global.GameMode.LEVEL_EDITOR
			
			EntityIDMapper.load_entity_map()
			Global.transition_to_scene("res://Scenes/Levels/LevelEditor.tscn")

func convert_custom_objects_path(resource_path := "", short := false) -> String:
	var short_path := "res://Assets/"
	var final_path := "res://Assets/CustomObjects"
	
	var record_from_here := 0
	for subdir in Array(resource_path.split("/")):
		if (record_from_here >= 3 && subdir.to_lower() != "assets"):
			short_path = short_path.path_join(subdir)
		if (record_from_here >= 1):
			final_path = final_path.path_join(subdir)
			record_from_here += 1
		if (record_from_here < 1):
			if (subdir == "custom_objects-unpacked"):
				record_from_here = 1
			elif (subdir == "mods-unpacked"):
				record_from_here = 1
	
	if (short):
		return short_path
	
	return final_path
