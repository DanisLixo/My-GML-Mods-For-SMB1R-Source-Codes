# This script is mostly copied from the original Fire state

extends PowerUpState

var bubble_amount := 0
var cooldown_amount := 0
var cooldown := 0.0
const BUBBLE = preload("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/Projectiles/PlayerBubble.tscn")

func update(delta: float) -> void:
	if player == null:
		player = get_parent().get_parent()
	if damage_state == null:
		damage_state = get_parent().get_node_or_null("Big")
	if Global.player_action_just_pressed("action", player.player_id) and cooldown_amount < 2 and bubble_amount < 6 and player.state_machine.state.name == "Normal":
		throw_bubble()
	
	if cooldown > 0:
		cooldown -= delta
		if cooldown <= 0:
			cooldown_amount = 0

func throw_bubble() -> void:
	var node = BUBBLE.instantiate()
	node.get_node("Coin").hide()
	node.character = player.character
	node.global_position = player.global_position - Vector2(-4 * player.direction, 16 * player.gravity_vector.y)
	node.direction = player.direction
	#node.velocity.y = player.velocity.y * 0.1
	node.speed = 120 + (player.velocity.x * node.direction * 0.45)
	node.speed = max(20, node.speed)
	node.player_cooldown = 0.5
	player.call_deferred("add_sibling", node)
	node.tree_exited.connect(func(): bubble_amount -= 1)
	bubble_amount += 1
	cooldown_amount += 1
	AudioManager.play_sfx("fireball", player.global_position)
	player.attacking = true
	await get_tree().create_timer(0.1, false).timeout
	player.attacking = false
	
	if cooldown_amount == 1:
		cooldown = 1
