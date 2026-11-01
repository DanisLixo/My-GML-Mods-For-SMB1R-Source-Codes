extends "res://Scripts/Parts/EndFlagpole.gd"

var players_reached := 0
static var alreadyDone := false

func player_touch(player: Player) -> void:
	var ps := get_tree().get_nodes_in_group("Players").duplicate()
	var onlyPlayer := ps.size() == 1
	
	if (onlyPlayer):
		super(player)
		return
	
	for i in get_tree().get_nodes_in_group("Players"):
		var ai = i.get_meta("thingie")
		if (ai != null):
			if (ai.isEnemy || ai.PARTNER_BEHAVIOR == 4):
				ps.erase(i)
	
	if (player.state_machine.get_state() != "FlagPole"):
		players_reached += 1
	if (player.get_meta("thingie").is_leader()):
		for follower in player.get_meta("thingie").partners:
			if (follower != null 
			&& follower.state_machine.get_state() != "FlagPole"):
				follower.global_position = follower.get_meta("thingie").leader.global_position + Vector2(-32, -(32 + ((16 * players_reached))))
			else:
				players_reached += 1
	
	player.state_machine.transition_to("FlagPole")
	player.global_position.x = $FlagJoint/Flag.global_position.x + 3
	give_points(player)
	Global.can_time_tick = false
	if (players_reached < ps.size()): 
		await get_tree().create_timer(5.0, true).timeout
	
	if (!alreadyDone):
		alreadyDone = true
	else:
		return
	
	super(player)

func _exit_tree() -> void:
	alreadyDone = false
