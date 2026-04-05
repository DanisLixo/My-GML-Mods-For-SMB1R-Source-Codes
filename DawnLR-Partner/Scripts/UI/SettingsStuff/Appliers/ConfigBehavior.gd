extends Node

@onready var PartnerSettings = get_node("/root/ModLoader/DawnLR-Partner/PartnerSettingsManager")

func set_value(value_name := "", value = null) -> void:
	{
		"eneny_spawn_delay": null
	}[value_name].call(value)

func enemy_spawn_delay_changed(new_value: Variant) -> void:
	PartnerSettings.file.selector.enemy_spawn_delay = new_value
	PartnerSettings.save_settings()

func a_partner_behavior_changed(new_value: Variant, player_id: int) -> void:
	PartnerSettings.file.selector.behavior[player_id] = new_value
	PartnerSettings.save_settings()
