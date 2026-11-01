extends Node

@onready var GBCRES = Settings.get_meta("GBCResMod")

func on_value_changed(new_value: Variant) -> void:
	GBCRES.file.video.enabled = new_value
	GBCRES.save_settings()
