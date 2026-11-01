extends Object

var player: Player
var thingie: Node

func _ready(c: ModLoaderHookChain) -> void:
	player = c.reference_object
	
	if (Settings.file.selector.amount > 0 && ![Global.GameMode.MARATHON, Global.GameMode.MARATHON_PRACTICE, Global.GameMode.LEVEL_EDITOR].has(Global.current_game_mode)):
		set_partner_mod_stuff()
		
		if (thingie.is_leader()):
			player.set_collision_mask_value(13, true)
	
	c.execute_next()

func _physics_process(c: ModLoaderHookChain, delta: float) -> void:
	set_essencials(c, true)
	
	c.execute_next([delta])
	
	if (thingie == null): return
	
	if (player.get_meta("PowerStateDifference") == 2):
		player.set_meta("PowerStateDifference", 0)

func get_power_up(c: ModLoaderHookChain, power_name := "", give_points := true) -> void:
	set_essencials(c, true)
	
	if (thingie == null): 
		c.execute_next_async([power_name, give_points])
		return
	
	if (thingie.is_leader()):
		c.execute_next_async([power_name, give_points])
	else:
		if (thingie.PARTNER_PERMANENT_SIZE != 1):
			c.execute_next_async([power_name, give_points])
	thingie.save_character_state(false)
	
	if (thingie.PARTNER_POWER_EXCLUSIVE || Settings.file.cpu_options.power_up_exclusivity == 1): return
	
	player.set_meta("PowerStateDifference", 1)
	for partner in thingie.partners:
		if (partner != null && partner.get_meta("PowerStateDifference") == 0 && !partner.get_meta("thingie").isEnemy):
			partner.get_power_up(power_name, false)
	
	set_essencials(c, true)
	player.set_meta("PowerStateDifference", 2)

func super_star(c: ModLoaderHookChain):
	set_essencials(c, true)
	c.execute_next()
	
	if (thingie == null): return
	if (thingie.PARTNER_POWER_EXCLUSIVE || Settings.file.cpu_options.power_up_exclusivity == 1): return
	
	for partner in thingie.partners:
		if (partner != null && !partner.has_star && !partner.get_meta("thingie").isEnemy):
			partner.super_star()

func wing_get(c: ModLoaderHookChain) -> void:
	set_essencials(c, true)
	c.execute_next()
	
	if (thingie == null): return
	if (thingie.PARTNER_POWER_EXCLUSIVE || Settings.file.cpu_options.power_up_exclusivity == 1): return
	
	for partner in thingie.partners:
		if (partner != null && !partner.has_wings && !partner.get_meta("thingie").isEnemy):
			partner.wing_get()
			
func hammer_get(c: ModLoaderHookChain) -> void:
	set_essencials(c, true)
	c.execute_next()
	
	if (thingie == null): return
	if (thingie.PARTNER_POWER_EXCLUSIVE || Settings.file.cpu_options.power_up_exclusivity == 1): return
	
	for partner in thingie.partners:
		if (partner != null && !partner.has_hammer && !partner.get_meta("thingie").isEnemy):
			partner.hammer_get()

func throw_projectile(c: ModLoaderHookChain) -> void:
	set_essencials(c, true)
	
	if (thingie == null):
		c.execute_next_async()
	else:
		thingie.throw_projective_with_thingie()

func on_area_entered(c: ModLoaderHookChain, area: Area2D) -> void:
	set_essencials(c, true)
	
	if (thingie == null): return
	
	var obj := area.owner
	if (obj is Player):
		var difCheck = area.owner.global_position.y > player.global_position.y + 8
		if (player.state_machine.get_state() == "FlagPole" && difCheck):
			player.state_machine.state.set_meta("playerUnderMe", true)
	elif (obj is Projectile):
		if (obj.get_meta("player") != null):
			if (!thingie.partners.has(obj.get_meta("player"))
			&& obj.get_meta("player") != player && player.can_hurt && obj.get_meta("player").get_meta("thingie").isEnemy):
				player.damage()

func on_area_exited(c: ModLoaderHookChain, area: Area2D):
	set_essencials(c, true)
	
	c.execute_next([area])
	
	if (player.state_machine.get_state() == "FlagPole"):
		player.state_machine.state.set_meta("playerUnderMe", false)

func handle_step_collision(c: ModLoaderHookChain) -> void:
	set_essencials(c, true)
	
	if (thingie == null):
		c.execute_next()
		return
	
	var collision_size = player.physics_params("COLLISION_SIZE")
	if player.crouching:
		collision_size = player.physics_params("CROUCH_COLLISION_SIZE")
	collision_size = Vector2(collision_size[0], collision_size[1])
	for i in player.get_meta("stepCollisions"):
		var on_wall := false
		for x in [player.get_node("StepWallChecks/LWall"), player.get_node("StepWallChecks/RWall")]:
			x.position.x = ((collision_size.x / 2) + 1) * sign(x.position.x)
			if x.is_colliding():
				on_wall = true
		var step_enabled = (not on_wall and (player.actual_velocity_y()) >= 0 and abs(player.velocity.x) > 5)
		i.set_deferred("disabled", not step_enabled)
		i.position.x = ((collision_size.x / 2)) * sign(i.position.x)
		i.position.x += 1 * sign(i.position.x)

func set_partner_mod_stuff() -> void:
	var thingieNode = load("res://mods-unpacked/DawnLR-Partner/Modded/Gameplay/Scripts/Classes/PartnerThingie.gd").new()
	thingieNode.name = "PartnerThingie"
	player.add_child(thingieNode)
	player.set_meta("thingie", thingieNode)
	thingie = thingieNode
	
	if (thingie.is_leader()):
		thingie.leader = player
	player.set_meta("PowerStateDifference", 0)
	player.set("thingie", thingieNode)
	
	var stepCollisions := []
	for step in player.get_tree().get_nodes_in_group("StepCollision"):
		if (step in player.get_children()):
			stepCollisions.append(step)
	player.set_meta("stepCollisions", stepCollisions)

func play_animation(c: ModLoaderHookChain, animation_name := "", force := false) -> void:
	set_essencials(c, true)
	if (thingie != null):
		thingie.playerOverride = animation_name 
	c.execute_next([animation_name, force])

func set_essencials(chain: ModLoaderHookChain, setthingie: bool = false) -> void:
	player = chain.reference_object
	if (player.get_meta("thingie", player) == player):
		return
	thingie = player.get_meta("thingie") if (setthingie) else thingie
