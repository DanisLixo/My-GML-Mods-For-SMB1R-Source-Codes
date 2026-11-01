extends Object

const MUSHROOM_PATH := "res://Scenes/Prefabs/Entities/Items/SuperMushroom.tscn"
const FLOWER_PATH := "res://Scenes/Prefabs/Entities/Items/FireFlower.tscn"
const HAMMERSUIT_PATH := "res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerUps/HammerSuit.tscn"
const BUBBLE_PATH := "res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerUps/BubbleFlower.tscn"
const BLUESHELL_PATH := "res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerUps/BlueShell.tscn"


var powerups_paths = {
	"Hammer Suit": preload("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerUps/HammerSuit.tscn"),
	"Bubble Flower": preload("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerUps/BubbleFlower.tscn"),
	"Boomerang": preload("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerUps/BoomerangFlower.tscn"),
	"Super Carrot": preload("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerUps/SuperCarrot.tscn"),
	"Superball": preload("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerUps/SuperBallFlower.tscn"),
	"Blue Shell": preload("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerUps/BlueShell.tscn"),
	"Turnip": preload("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/PowerUps/Turnip.tscn")
}


const SPORADIC_DISTRIBUTION := [
	"11",
	"13",
	"21",
	"22",
	"32",
	"34",
	"41",
	"44",
	"51",
	"53",
	"62",
	"63",
	"73",
	"74",
	"83",
	"82"
]

func _enter_tree(chain: ModLoaderHookChain):
	var refobj = chain.reference_object
	var mod_main = refobj.get_tree().root.get_node("ModLoader/DeGezondeRoker-TooManyPowerUps")
	#print(mod_main.world_distribution[Global.world_num - 1])
	#print(mod_main.world_powerups[Global.world_num - 1])
	
	chain.execute_next()
	
	if chain.reference_object.item != null:
		if chain.reference_object.item.get_path() in FLOWER_PATH:
			if mod_main.world_powerups[Global.world_num - 1] == "Flower":
				return
			var current_world_level = str(Global.world_num) + str(Global.level_num)
			var replace = true
			var distribution = mod_main.world_distribution[Global.world_num - 1]
			if distribution == "None":
				return
			if distribution == "Sporadic":
				if current_world_level not in SPORADIC_DISTRIBUTION:
					return
			if replace:
				var path = powerups_paths[mod_main.world_powerups[Global.world_num - 1]]
				chain.reference_object.item = path

#func dispense_item(chain: ModLoaderHookChain):
	#var refobj = chain.reference_object
	#var mod_main = refobj.get_tree().root.get_node("ModLoader/DeGezondeRoker-TooManyPowerUps")
	#
	#if is_instance_valid(Global.level_editor):
		#if chain.reference_object.item != null:
			#if chain.reference_object.item.get_path() == FLOWER_PATH:
				#var path = powerups_paths[mod_main.config_editorpowerup]
				#print(path)
				#chain.reference_object.item = load(path)
	#chain.execute_next_async()

func player_mushroom_check(chain: ModLoaderHookChain, player: Player = null):
	var refobj = chain.reference_object
	var mod_main = refobj.get_tree().root.get_node("ModLoader/DeGezondeRoker-TooManyPowerUps")
	if mod_main.config_skipmushroom == true:
		return refobj.item
	return chain.execute_next([player])
