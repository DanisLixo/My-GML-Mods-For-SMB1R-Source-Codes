extends Node

@onready var PartnerSettings = get_node("/root/ModLoader/DawnLR-Partner/PartnerSettingsManager")

func set_value(value_name := "", value = null) -> void:
	{
		"permanent_size": permanent_size_changed, 
		"power_up_exclusivity": power_up_exclusivity_changed, 
		"muted": muted_changed,
		"apply_physics": apply_partner_physics_changed, 
		"respawn_time": respawn_time_changed
	}[value_name].call(value)

func permanent_size_changed(new_value: Variant) -> void:
	PartnerSettings.file.cpu_options.permanent_size = new_value
	PartnerSettings.save_settings()

func power_up_exclusivity_changed(new_value: Variant) -> void:
	PartnerSettings.file.cpu_options.power_up_exclusivity = new_value
	PartnerSettings.save_settings()

func muted_changed(new_value: Variant) -> void:
	PartnerSettings.file.cpu_options.muted = new_value
	PartnerSettings.save_settings()

func apply_partner_physics_changed(new_value: Variant) -> void:
	PartnerSettings.file.cpu_options.apply_physics = new_value
	PartnerSettings.save_settings()

func respawn_time_changed(new_value: Variant) -> void:
	PartnerSettings.file.cpu_options.respawn_time = new_value
	PartnerSettings.save_settings()
