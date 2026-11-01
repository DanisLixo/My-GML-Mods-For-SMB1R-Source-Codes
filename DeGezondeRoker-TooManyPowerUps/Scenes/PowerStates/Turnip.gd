# This script is mostly copied from the original Fire state

extends PowerUpState

var projectile_amount := 0
var projectile = load("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/Projectiles/Turnip.tscn")

func update(_delta: float) -> void:
	if player == null:
		player = get_parent().get_parent()
	if damage_state == null:
		damage_state = get_parent().get_node_or_null("Big")
	if Global.player_action_just_pressed("action", player.player_id) and projectile_amount < 2 and player.state_machine.state.name == "Normal":
		throw_hammer()

func throw_hammer() -> void:
	var node = projectile.instantiate()
	node.character = player.character
	node.global_position = player.global_position - Vector2(-4 * player.direction, 16 * player.gravity_vector.y)
	node.direction = player.direction
	node.velocity.y = -120
	if player.velocity.y < 0:
		node.velocity.y += player.velocity.y * 1.2
	node.speed = (120 + abs(player.velocity.x) * 0.7)
	node.speed = max(60, node.speed)
	node.bounce_count = int(node.global_position.x) % 10
	player.call_deferred("add_sibling", node)
	projectile_amount += 1
	node.tree_exited.connect(func(): projectile_amount -= 1)
	AudioManager.play_sfx("fireball", player.global_position)
	player.attacking = true
	await get_tree().create_timer(0.1, false).timeout
	player.attacking = false
