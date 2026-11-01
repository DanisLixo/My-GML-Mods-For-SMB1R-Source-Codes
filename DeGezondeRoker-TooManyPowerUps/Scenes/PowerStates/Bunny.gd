# This script is mostly copied from the original Fire state

extends PowerUpState

var hovertimer = 0
var waithold = false
var sfx

func update(delta: float) -> void:
	if player == null:
		player = get_parent().get_parent()
	if damage_state == null:
		damage_state = get_parent().get_node_or_null("Big")
	if get_node_or_null("SFX"):
		sfx = get_node("SFX")
		remove_child(sfx)
		player.add_child(sfx)
	
	if player.state_machine.state.name == "Normal":
		if player.is_actually_on_floor():
			if Global.player_action_pressed("jump", player.player_id):
				player.handle_water_detection()
				if player.in_water or player.flight_meter > 0:
					pass
				else:
					player.jump()
		
		if hovertimer > 0:
			player.attacking = true
			player.velocity.y = min(player.velocity.y, 5)
			hovertimer -= delta
			if hovertimer <= 0:
				player.attacking = false
		
		if player.is_actually_on_floor():
			waithold = false
		
		if Global.player_action_just_pressed("jump", player.player_id) and player.state_machine.state.name == "Normal" and player.is_actually_on_floor() == false and player.velocity.y > 0:
			hover()
			waithold = true
			player.has_jumped = true
		if Global.player_action_pressed("jump", player.player_id) and player.state_machine.state.name == "Normal" and player.is_actually_on_floor() == false and player.velocity.y > 0 and waithold == true:
			if player.attacking == false:
				hover()
		else:
			player.attacking = false
	else:
		player.attacking = false

func hover() -> void:
	sfx.play()
	hovertimer = .2
	player.velocity.y = -10
