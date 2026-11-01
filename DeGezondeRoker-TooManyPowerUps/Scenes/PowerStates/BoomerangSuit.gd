# This script is mostly copied from the original Fire state

extends PowerUpState

var hammer_amount := 0
var projectile = load("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/Projectiles/PlayerBoomerang.tscn")

func update(_delta: float) -> void:
	if player == null:
		player = get_parent().get_parent()
	if damage_state == null:
		damage_state = get_parent().get_node_or_null("Big")
	if Global.player_action_just_pressed("action", player.player_id) and hammer_amount < 1 and player.state_machine.state.name == "Normal":
		throw_hammer()

func throw_hammer() -> void:
	var node = projectile.instantiate()
	node.character = player.character
	node.global_position = player.global_position - Vector2(-4 * player.direction, 16 * player.gravity_vector.y)
	node.direction = player.direction
	node.speed = 200 + (player.velocity.x * node.direction * 0.3)
	node.speed = max(20, node.speed)
	node.velocity.x = node.speed * node.direction
	player.call_deferred("add_sibling", node)
	hammer_amount += 1
	node.tree_exited.connect(func(): hammer_amount -= 1)
	AudioManager.play_sfx("fireball", player.global_position)
	player.attacking = true
	await get_tree().create_timer(0.1, false).timeout
	player.attacking = false
