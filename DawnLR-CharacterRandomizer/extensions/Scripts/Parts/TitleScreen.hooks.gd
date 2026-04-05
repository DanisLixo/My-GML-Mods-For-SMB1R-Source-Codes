extends Object

var kid: Control = null
var okYeah := false

func _ready(c: ModLoaderHookChain) -> void:
	c.execute_next()
	var obj = c.reference_object
	var characterRandomizer = obj.get_node("/root/ModLoader/DawnLR-CharacterRandomizer/CharacterRandomizer")
	if (characterRandomizer.file.options.alwaysShowInitialWarning != 0):
		obj = c.reference_object.get_node("CanvasLayer")
		kid = load("res://mods-unpacked/DawnLR-CharacterRandomizer/Scenes/Prefabs/UI/Randomizer/RandomizerFirstStart.tscn").instantiate()
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
			
			var characterRandomizer = obj.get_node("/root/ModLoader/DawnLR-CharacterRandomizer/CharacterRandomizer")
			if (characterRandomizer.file.options.alwaysShowInitialWarning == 2):
				characterRandomizer.file.options.alwaysShowInitialWarning = 0
				characterRandomizer.save_settings()
	

func _exit_tree(chain: ModLoaderHookChain) -> void:
	chain.execute_next()
	
	var characterRandomizer = chain.reference_object.get_node("/root/ModLoader/DawnLR-CharacterRandomizer/CharacterRandomizer")
	characterRandomizer.firstLoad = true
