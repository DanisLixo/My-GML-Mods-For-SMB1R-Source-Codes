extends Object

var kid: Control = null
var okYeah := false

var RandomizerSettings

func _ready(c: ModLoaderHookChain) -> void:
	c.execute_next()
	var obj = c.reference_object
	RandomizerSettings = Settings.get_meta("RandomizerMod")
	RandomizerSettings.user_list_not_random_idx = 0
	if (RandomizerSettings.file.options.alwaysShowInitialWarning != 0):
		obj = c.reference_object.get_node("CanvasLayer")
		kid = load("res://mods-unpacked/DawnLR-CharacterRandomizer/Modded/UI/Randomizer/RandomizerFirstStart.tscn").instantiate()
		obj.add_child(kid)

func _process(c: ModLoaderHookChain, delta: float) -> void:
	c.execute_next([delta])
	var obj = c.reference_object
	if (!okYeah):
		if (kid != null):
			obj.active_options.active = false
		else:
			obj.active_options.active = true
			okYeah = true
			
			if (RandomizerSettings.file.options.alwaysShowInitialWarning == 2):
				RandomizerSettings.file.options.alwaysShowInitialWarning = 0
				RandomizerSettings.save_settings()

func _exit_tree(chain: ModLoaderHookChain) -> void:
	chain.execute_next()
	
	RandomizerSettings.firstLoad = true
