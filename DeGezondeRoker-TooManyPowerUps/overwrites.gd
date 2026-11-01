extends Node


var vanilla_file_paths: Array[String] = [
	# Palettes
	"res://Assets/Sprites/Players/Mario/ModdedPalette.json",
	"res://Assets/Sprites/Players/Mario/ModdedPalette.png",
	"res://Assets/Sprites/Players/Luigi/ModdedPalette.json",
	"res://Assets/Sprites/Players/Luigi/ModdedPalette.png",
	"res://Assets/Sprites/Players/Toad/ModdedPalette.json",
	"res://Assets/Sprites/Players/Toad/ModdedPalette.png",
	"res://Assets/Sprites/Players/Toadette/ModdedPalette.json",
	"res://Assets/Sprites/Players/Toadette/ModdedPalette.png",
]
var overwrite_file_paths: Array[String] = [
	# Palettes
	"res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/overwrites/Assets/Sprites/Players/Mario/ModdedPalette.json",
	"res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/overwrites/Assets/Sprites/Players/Mario/ModdedPalette.png",
	"res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/overwrites/Assets/Sprites/Players/Luigi/ModdedPalette.json",
	"res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/overwrites/Assets/Sprites/Players/Luigi/ModdedPalette.png",
	"res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/overwrites/Assets/Sprites/Players/Toad/ModdedPalette.json",
	"res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/overwrites/Assets/Sprites/Players/Toad/ModdedPalette.png",
	"res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/overwrites/Assets/Sprites/Players/Toadette/ModdedPalette.json",
	"res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/overwrites/Assets/Sprites/Players/Toadette/ModdedPalette.png",
]

var new_items: Array[String] = [
	"HammerSuit",
	"PlayerHammer",
	"PlayerHammerL",
	"PlayerHammerT",
	"PlayerHammerTT",
	"BubbleFlower",
	"Bubble",
	"BoomerangFlower",
	"PlayerBoomerang",
	"SuperCarrot",
	"SuperBallFlower",
	"SuperBall",
	"Shell",
	"Turnip",
	"PlayerTurnip",
	"TurnipPart"
]

var powerstates: Array[String] = [
	"HammerSuit",
	"Bubble",
	"BoomerangSuit",
	"Bunny",
	"SuperBall",
	"Shell",
	"Turnip"
]


var overwrite_resources := []


func _init():
	for i in overwrite_file_paths.size():
		var vanilla_path := vanilla_file_paths[i]
		var overwrite_path := overwrite_file_paths[i]

		var overwrite_resource := load(overwrite_path)
		overwrite_resources.push_back(overwrite_resource)
		overwrite_resource.take_over_path(vanilla_path)
	
	for i in powerstates:
		for j in ["Mario", "Luigi", "Toad", "Toadette"]:
			var vanilla_sheet	= "res://Assets/Sprites/Players/" + j + "/" + i + ".png"
			var vanilla_json	= "res://Assets/Sprites/Players/" + j + "/" + i + ".json"
			var overwrite_sheet	= "res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/overwrites/Assets/Sprites/Players/" + j + "/" + i + ".png"
			var overwrite_json	= "res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/overwrites/Assets/Sprites/Players/" + j + "/" + i + ".json"

			var overwrite_resource = load(overwrite_sheet)
			overwrite_resources.push_back(overwrite_resource)
			overwrite_resource.take_over_path(vanilla_sheet)
			
			overwrite_resource = load(overwrite_json)
			overwrite_resources.push_back(overwrite_resource)
			overwrite_resource.take_over_path(vanilla_json)

	for i in new_items.size():
		var vanilla_sheet	= "res://Assets/Sprites/ModdedItems/" + new_items[i] + ".png"
		var vanilla_json	= "res://Assets/Sprites/ModdedItems/" + new_items[i] + ".json"
		var overwrite_sheet	= "res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/overwrites/Assets/Sprites/ModdedItems/" + new_items[i] + ".png"
		var overwrite_json	= "res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/overwrites/Assets/Sprites/ModdedItems/" + new_items[i] + ".json"

		var overwrite_resource = load(overwrite_sheet)
		overwrite_resources.push_back(overwrite_resource)
		overwrite_resource.take_over_path(vanilla_sheet)
		
		overwrite_resource = load(overwrite_json)
		if overwrite_resource != null:
			overwrite_resources.push_back(overwrite_resource)
			overwrite_resource.take_over_path(vanilla_json)
