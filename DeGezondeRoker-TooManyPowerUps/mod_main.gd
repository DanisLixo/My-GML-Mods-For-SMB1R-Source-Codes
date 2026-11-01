extends Node


const MOD_DIR := "DeGezondeRoker-TooManyPowerUps"
const LOG_NAME := "DeGezondeRoker-TooManyPowerUps:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

var new_power_states := ["Small", "Big", "Fire", "Superball", "HammerSuit", "Bubble", "BoomerangSuit", "Bunny", "SuperBall", "Shell", "Turnip"]

var config_editorpowerup
var config_forcepowerup
var config_skipmushroom

var world_powerups = [
	"Flower",
	"Hammer Suit",
	"Flower",
	"Hammer Suit",
	"Hammer Suit",
	"Hammer Suit",
	"Hammer Suit",
	"Hammer Suit",
	"Hammer Suit",
	"Hammer Suit"
]

var world_distribution = [
	"All",
	"All",
	"All",
	"All",
	"All",
	"All",
	"All",
	"All",
	"All",
	"All"
]

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)
	# Add extensions
	install_script_extensions()
	install_script_hook_files()


func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")


func install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	# Original script reads through a constant array of power up states, hook makes it read through a new array
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/PlayerSprite.gd", extensions_dir_path.path_join("Scripts/Parts/PlayerSprite.hooks.gd"))
	# Replaces Fowers in certain levels with Hammer Suits
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Blocks/BlockClass.gd", extensions_dir_path.path_join("Scripts/Classes/Blocks/BlockClass.hooks.gd"))
	# Fireball immunity
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Entities/Enemy.gd", extensions_dir_path.path_join("Scripts/Classes/Entities/Enemy.hooks.gd"))
	# uh
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/States/Player/Normal.gd", extensions_dir_path.path_join("Scripts/Classes/States/Player/Normal.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Components/EnemyPlayerDetection.gd", extensions_dir_path.path_join("Scripts/Classes/Components/EnemyPlayerDetection.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/LevelClass.gd", extensions_dir_path.path_join("Scripts/Classes/LevelClass.hooks.gd"))
	# Original script reads through a constant array of power up states, hook overwrites anything power-up related in this function
	# Also adds the new power up state by instancing it in _ready()
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/Entities/Player.gd", extensions_dir_path.path_join("Scripts/Classes/Entities/Player.hooks.gd"))


func _ready() -> void:
	pass
