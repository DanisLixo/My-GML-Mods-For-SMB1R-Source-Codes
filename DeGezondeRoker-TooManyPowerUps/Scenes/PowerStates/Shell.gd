# This script is mostly copied from the original Fire state

extends PowerUpState

var sliding := false
var slide_direction = 1

func update(delta: float) -> void:
	if player == null:
		player = get_parent().get_parent()
	if damage_state == null:
		damage_state = get_parent().get_node_or_null("Big")
	
	if player.state_machine.state.name == "Normal":
		if player.is_actually_on_floor() and player.crouching and ((player.physics_params("RUN_SPEED") - abs(player.velocity.x)) < 4):
			sliding = true
			slide_direction = -1
			if player.velocity.x > 0:
				slide_direction = 1
		
		if sliding:
			if player.crouching == false: #and Global.player_action_pressed("run", player.player_id) == false:
				sliding = false
				return
				
			if player.is_actually_on_wall():
				slide_direction *= -1
				AudioManager.play_sfx("bump", player.global_position)
				
			player.velocity.x = player.physics_params("RUN_SPEED") * slide_direction
			
			handle_block_collision(delta)
	else:
		sliding = false

func handle_block_collision(_delta: float) -> void:
	if ["Pipe"].has(player.state_machine.state.name): return
	player.get_node("ShellCollision").position.x = 4 * slide_direction
	
	for i in player.get_node("ShellCollision").get_overlapping_bodies():
		if i is Block:
			if player.is_actually_on_wall():
				i.player_block_hit.emit(player)
				return
	
