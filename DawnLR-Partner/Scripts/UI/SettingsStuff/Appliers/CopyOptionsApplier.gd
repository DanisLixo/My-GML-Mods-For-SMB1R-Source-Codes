extends Node

@onready var PartnerSettings = get_node("/root/ModLoader/DawnLR-Partner/PartnerSettingsManager")

func set_value(value_name := "", value = null) -> void:
	{
		"permanent_size": permanent_size_changed, 
		"muted": muted_changed
	}[value_name].call(value)

func permanent_size_changed(new_value: Variant) -> void:
	PartnerSettings.file.copy_options.permanent_size = new_value
	PartnerSettings.save_settings()

func muted_changed(new_value: Variant) -> void:
	PartnerSettings.file.copy_options.muted = new_value
	PartnerSettings.save_settings()
