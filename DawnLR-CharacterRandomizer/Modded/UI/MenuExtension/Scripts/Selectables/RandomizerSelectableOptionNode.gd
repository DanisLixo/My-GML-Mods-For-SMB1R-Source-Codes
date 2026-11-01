extends "res://Scripts/UI/SelectableOptionNode.gd"

@onready var RandomizerSettings = Settings.get_meta("RandomizerMod")

func _process(delta: float):
	if (Global.multibind_action_just_pressed("ui_toggle_randomizer")):
		update_starting_values()
	
	super(delta)

func update_starting_values() -> void:
	if RandomizerSettings.file.has(settings_category):
		if RandomizerSettings.file[settings_category].has(option_key):
			if RandomizerSettings.file[settings_category][option_key] is String:
				selected_index = values.find(RandomizerSettings.file[settings_category][option_key])
			else:
				selected_index = RandomizerSettings.file[settings_category][option_key]
