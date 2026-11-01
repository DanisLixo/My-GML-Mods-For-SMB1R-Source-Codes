extends Object

func _ready(chain: ModLoaderHookChain) -> void:
	var RandomizerSettings = Settings.get_meta("RandomizerMod")
	
	RandomizerSettings.load_settings()
	
	var can_randomize = (RandomizerSettings.firstLoad && RandomizerSettings.file.options.randomize_on_start) || !RandomizerSettings.firstLoad
	if (can_randomize):
		var randomizer = load("res://mods-unpacked/DawnLR-CharacterRandomizer/Modded/Scripts/Randomizer.gd").new()
		randomizer.start_randomizing()
	
	chain.execute_next_async()
	
