extends Node

@onready var PartnerSettings = get_node("/root/ModLoader/DawnLR-Partner/PartnerSettingsManager")

signal follow_mode_changed
signal amount_changed(value: int)

func set_value(value_name := "", value = null) -> void:
	{
		"follow_mode": partner_follow_mode_changed,
		"partners_amount": partners_amount_changed,
		"unlock_limit": unlock_limit_changed
	}[value_name].call(value)

func partner_follow_mode_changed(new_value: Variant) -> void:
	PartnerSettings.file.selector.follow_mode = new_value
	PartnerSettings.save_settings()
	
	follow_mode_changed.emit()

func partners_amount_changed(new_value: int) -> void:
	PartnerSettings.file.selector.amount = new_value
	%PartnerList.update_partner_options(PartnerSettings.file.selector.amount)
	%BehaviorList.update_behavior_options(PartnerSettings.file.selector.amount)

func a_partner_id_changed(new_value: Variant, player_id: int) -> void:
	Global.player_characters[player_id] = new_value
	
	PartnerSettings.file.selector.characters[player_id] = Global.player_characters[player_id]
	PartnerSettings.save_settings()

func unlock_limit_changed(new_value: Variant) -> void:
	PartnerSettings.file.selector.unlock_limit = new_value
	
	if (new_value == 0 && PartnerSettings.file.selector.amount > 7):
		PartnerSettings.file.selector.amount = 7
	
	%PartnerList.update_partner_options(PartnerSettings.file.selector.amount)
