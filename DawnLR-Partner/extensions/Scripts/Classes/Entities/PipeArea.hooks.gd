extends Object

func exit_pipe(c: ModLoaderHookChain) -> void:
	var piper: PipeArea = c.reference_object
	if (Settings.file.partners.amount == 0):
		c.execute_next_async()
		return
	
	piper.can_enter = false
	piper.pipe_exited.emit()
	
	for i in piper.get_tree().get_nodes_in_group("Players-AI"):
		i.hide()
	
	var player := piper.get_tree().get_first_node_in_group("Players")
	if player.is_node_ready() == false:
		await player.ready
	player.go_to_exit_pipe(piper)
	
	await piper.get_tree().create_timer(0.5, false).timeout
	
	if is_instance_valid(player):
		await player.exit_pipe(piper)
		await piper.get_tree().create_timer(0.1, false).timeout
	
	if (piper == null): return
	
	piper.exiting_pipe_id = -1
	piper.can_enter = true
	
	if (player == null):
		return
	
	for i in piper.get_tree().get_nodes_in_group("Players-AI"):
		if (i is not Player):
			continue
		if i.is_node_ready() == false:
			await i.ready
		if (!i.thingie.isEnemy):
			i.thingie.partnerState = i.thingie.FollowStage.RETURN
			i.go_to_exit_pipe(piper)
	
	for i in piper.get_tree().get_nodes_in_group("Players-AI"):
		if (!i.thingie.isEnemy):
			await i.exit_pipe(piper)
