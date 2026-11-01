extends Node

@onready var RandomizerSettings = Settings.get_meta("RandomizerMod")

func enabled_toggled(new_value: Variant) -> void:
	RandomizerSettings.file.options.enabled = new_value
	RandomizerSettings.save_settings()

func on_start_changed(new_value: Variant) -> void:
	RandomizerSettings.file.options.randomize_on_start = new_value
	RandomizerSettings.save_settings()

func on_transition_changed(new_value: Variant) -> void:
	RandomizerSettings.file.options.every_transition = new_value
	RandomizerSettings.save_settings()

func one_shot_changed(new_value: Variant) -> void:
	RandomizerSettings.file.options.one_shot_characters = new_value
	RandomizerSettings.save_settings()

func not_random_changed(new_value: Variant) -> void:
	RandomizerSettings.file.options.not_random = new_value
	RandomizerSettings.save_settings()

func user_list_use_changed(new_value: Variant) -> void:
	RandomizerSettings.file.options.use_user_character_list = new_value
	RandomizerSettings.save_settings()

func leader_only_changed(new_value: Variant) -> void:
	RandomizerSettings.file.options.randomize_player_one_only = new_value
	RandomizerSettings.save_settings()
