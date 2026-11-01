extends Node

signal follow_mode_changed
signal amount_changed(value: int)

func partner_follow_mode_changed(new_value: Variant) -> void:
	Settings.file.partners.follow_mode = new_value
	Settings.save_settings()
	
	follow_mode_changed.emit()

func partners_amount_changed(new_value: int) -> void:
	Settings.file.partners.amount = new_value

func unlock_limit_changed(new_value: Variant) -> void:
	Settings.file.partners.unlock_limit = new_value
	
	if (new_value == 0 && Settings.file.partners.amount > 7):
		Settings.file.partners.amount = 7

func enemy_spawn_delay_changed(new_value: Variant) -> void:
	Settings.file.partners.enemy_spawn_delay = new_value
	Settings.save_settings()

func permanent_size_changed(new_value: Variant) -> void:
	Settings.file.partners.cpu_permanent_size = new_value
	Settings.save_settings()

func power_up_exclusivity_changed(new_value: Variant) -> void:
	Settings.file.partners.power_up_exclusivity = new_value
	Settings.save_settings()

func muted_changed(new_value: Variant) -> void:
	Settings.file.partners.cpu_muted = new_value
	Settings.save_settings()

func apply_partner_physics_changed(new_value: Variant) -> void:
	Settings.file.partners.apply_physics = new_value
	Settings.save_settings()

func respawn_time_changed(new_value: Variant) -> void:
	Settings.file.partners.respawn_time = new_value
	Settings.save_settings()

func copy_permanent_size_changed(new_value: Variant) -> void:
	Settings.file.partners.copy_permanent_size = new_value
	Settings.save_settings()

func copy_muted_changed(new_value: Variant) -> void:
	Settings.file.partners.copy_muted = new_value
	Settings.save_settings()

func a_partner_id_changed(new_value: Variant, player_id: int) -> void:
	Global.player_characters[player_id] = new_value
	
	Settings.file.partners.characters[player_id] = Global.player_characters[player_id]
	Settings.save_settings()

func a_partner_behavior_changed(new_value: Variant, player_id: int) -> void:
	Settings.file.partners.behavior[player_id] = new_value
	Settings.save_settings()
