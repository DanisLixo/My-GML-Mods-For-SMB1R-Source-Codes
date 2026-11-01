extends "res://Scripts/UI/SelectableOptionNode.gd"

@onready var GBCRES = Settings.get_meta("GBCResMod")

func _process(delta: float):
	super(delta)

func update_starting_values() -> void:
	if GBCRES.file.has(settings_category):
		if GBCRES.file[settings_category].has(option_key):
			if GBCRES.file[settings_category][option_key] is String:
				selected_index = values.find(GBCRES.file[settings_category][option_key])
			else:
				selected_index = GBCRES.file[settings_category][option_key]
