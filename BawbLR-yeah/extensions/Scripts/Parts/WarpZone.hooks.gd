extends Object

func activate(c: ModLoaderHookChain) -> void:
	var warp = c.reference_object
	
	if (warp.get_meta("stop", false)): 
		return
	
	warp.set_meta("stop", true)
	Global.can_time_tick = false
	fade_to_warp(c, AudioManager.music_player.volume_db)

func fade_to_warp(c: ModLoaderHookChain, old_volume) -> void:
	Global.current_level.can_backscroll = false
	
	for i in Global.get_tree().get_nodes_in_group("Plants"):
		i.queue_free()
	
	var warp := c.reference_object
	
	if warp.enable_sides:
		warp.get_node("Pipes/Left/Pipe").world_num = warp.pipe_destinations[0]
		warp.get_node("Pipes/Right/Pipe").world_num = warp.pipe_destinations[2]
	warp.get_node("Pipes/Middle/Pipe").world_num = warp.pipe_destinations[1]
	
	while (AudioManager.music_player.volume_db > -60.0):
		AudioManager.music_player.volume_db -= 50.0 * AudioManager.get_process_delta_time()
		await Global.get_tree().process_frame
	Global.current_level.music = load("res://mods-unpacked/BawbLR-yeah/Assets/BGM/WarpZone_split.json")
	await Global.get_tree().process_frame
	
	wow()
	
	while (AudioManager.music_player.volume_db < old_volume):
		AudioManager.music_player.volume_db += 50.0 * AudioManager.get_process_delta_time()
		if (AudioManager.music_player.volume_db > old_volume):
			AudioManager.music_player.volume_db = old_volume
			await Global.get_tree().process_frame
	
func wow() -> void:
	var idx := 0
	for i in Global.get_tree().get_nodes_in_group("Labels"):
		if (idx == 4):
			Global.current_level.music = load("res://mods-unpacked/BawbLR-yeah/Assets/BGM/WarpZone.json")
		await Global.get_tree().create_timer(1.03, true).timeout
		i.show()
		idx += 1
	
	Global.current_level.music = load("res://mods-unpacked/BawbLR-yeah/Assets/BGM/WarpZone.json")
	Global.can_time_tick = true
