extends TitleScreen

func _enter_tree() -> void:
	Global.current_game_mode = Global.GameMode.NONE
	Global.in_title_screen = true
	Global.current_room_type = room_type
	
	var pack_info_path = Global.config_path.path_join("resource_packs/Nestopia Tweaks/pack_info.json")
	if (FileAccess.file_exists(pack_info_path)):
		Settings.file.visuals.resource_packs.push_front("Nestopia Tweaks")
		
		Global.update_theme()
	Global.current_campaign = "SMB1"
	
	last_campaign = Global.current_campaign
	last_theme = "Overworld"
	
	Global.debugged_in = false
	title_first_load = false

func _ready() -> void:
	DiscoLevel.in_disco_level = false
	get_tree().paused = false
	
	%DevBuildWarning.visible = Global.is_snapshot
	
	AudioManager.stop_all_music()
	AudioManager.stop_music_override(AudioManager.MUSIC_OVERRIDES.NONE, true)
	
	Global.reset_values()
	Global.second_quest = false
	
	SpeedrunHandler.timer = 0
	SpeedrunHandler.timer_active = false
	SpeedrunHandler.show_timer = false
	
	SpeedrunHandler.ghost_active = false
	SpeedrunHandler.ghost_enabled = false
	Global.player_ghost.apply_data()
	get_tree().call_group("PlayerGhosts", "delete")
	
	Global.current_level = null
	Global.world_num = clamp(Global.world_num, 1, get_world_count())
	
	update_title()

func update_title() -> void:
	SaveManager.apply_save(SaveManager.load_save(Global.current_campaign))
	level_id = Global.level_num - 1
	world_id = Global.world_num
	
	update_theme()
	await get_tree().physics_frame
	$LevelBG.time_of_day = "Day"
	$LevelBG.update_visuals()

func play_bgm() -> void:
	if has_achievements_to_unlock:
		await get_tree().create_timer(3, false).timeout
		has_achievements_to_unlock = false
	if Settings.file.audio.menu_bgm == 1:
		await get_tree().physics_frame
		$BGM.play()

func _process(_delta: float) -> void:
	Global.can_time_tick = false
	cursor.global_position = active_options.options[active_options.selected_index].global_position - Vector2(8, -4)
	
	$BGM.stream_paused = Settings.file.audio.menu_bgm == 0
	if $BGM.is_playing() == false and Settings.file.audio.menu_bgm == 1 and has_achievements_to_unlock == false:
		$BGM.play()

func campaign_selected() -> void:
	$CanvasLayer/Options1.close()
	if last_campaign != Global.current_campaign:
		last_campaign = Global.current_campaign
		await update_title()
	if Global.current_campaign == "SMBANN":
		Global.current_game_mode = Global.GameMode.DISCO
		$CanvasLayer/AllNightNippon/WorldSelect.open()
		$%Options1.show()
		return
	$CanvasLayer/Options2.open()

func open_story_options() -> void:
	if Global.game_beaten:
		%QuestSelect.open()
		await %QuestSelect.selected
	$CanvasLayer/StoryMode/StoryOptions.selected_index = 1
	%Options2.close()
	$CanvasLayer/StoryMode/StoryOptions/HighScore.text = "Top- " + str(Global.high_score).pad_zeros(6)
	$CanvasLayer/Options1.close()
	$CanvasLayer/StoryMode/StoryOptions.open()

func continue_story() -> void:
	Global.current_game_mode = Global.GameMode.CAMPAIGN
	if Global.game_beaten or Global.debug_mode:
		go_back_to_first_level()
		$CanvasLayer/StoryMode/QuestSelect.open()
	else:
		$CanvasLayer/StoryMode/NoBeatenCharSelect.open()

func get_highscore() -> void:
	%HighScore.text = "TOP- " + str(Global.high_score).pad_zeros(6)
	if Global.world_num == 1 and Global.level_num == 1 and Global.score <= 0:
		%StoryOptions.selected_index = 0
	else:
		%StoryOptions.selected_index = 1

func clear_stats() -> void:
	Global.clear_saved_values()

func clear_custom_save() -> void:
	Global.world_num = 1
	Global.level_num = 1
	Global.custom_level_idx = 0
	Global.clear_saved_values()
	Global.reset_values()

func go_back_to_first_level() -> void:
	Global.world_num = 1
	Global.level_num = 1
	LevelTransition.level_to_transition_to = Level.get_scene_string(Global.world_num, Global.level_num)

func start_game() -> void:
	PipeCutscene.seen_cutscene = false
	first_load = true
	Global.reset_values()
	LevelEditor.sub_areas = [null, null, null, null, null]
	if Global.in_custom_campaign() == false:
		LevelTransition.level_to_transition_to = Level.get_scene_string(Global.world_num, Global.level_num)
	Global.transition_to_scene("res://Scenes/Levels/LevelTransition.tscn")

func _exit_tree() -> void:
	Global.in_title_screen = false

func world_9_selected() -> void:
	Global.second_quest = false
	Global.current_game_mode = Global.GameMode.CAMPAIGN
	Global.reset_values()
	Global.clear_saved_values()
	Global.world_num = 9
	Global.level_num = 1
	%ExtraWorldSelect.open()

func open_options() -> void:
	$CanvasLayer/SettingsMenu.open()
	active_options.active = false
	await $CanvasLayer/SettingsMenu.closed
	active_options.active = true

func quit_game() -> void:
	get_tree().quit()

func new_game_selected() -> void:
	Global.second_quest = false
	Global.current_game_mode = Global.GameMode.CAMPAIGN
	if Global.game_beaten:
		%QuestSelect.open()
	else:
		$CanvasLayer/StoryMode/NewUnbeatenGame/NoBeatenCharSelect.open()

func continue_game() -> void:
	SaveManager.apply_save(SaveManager.load_save(Global.current_campaign))
	Global.current_game_mode = Global.GameMode.CAMPAIGN
	if Global.game_beaten or Global.debug_mode:
		$CanvasLayer/StoryMode/ContinueBeatenGame/WorldSelect.open()
	else:
		$CanvasLayer/StoryMode/ContinueUnbeatenGame/CharacterSelect.open()

func on_story_options_closed() -> void:
	$CanvasLayer/Options1.open()
