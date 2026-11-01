extends Node


const MOD_DIR := "BawbLR-SMASTransition"
const LOG_NAME := "BawbLR-SMASTransition:Main"

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



func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")

@onready var transitionLayer: CanvasLayer = load("res://mods-unpacked/BawbLR-SMASTransition/TransitionLayer.tscn").instantiate()
func _ready() -> void:
	add_child(transitionLayer)
	transitionLayer.name = "TransitionLayer"
