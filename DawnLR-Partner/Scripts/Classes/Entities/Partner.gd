class_name Partner extends Player

#region Partner shit (a lot is from Sonic Worlds Next and my gmSMB mod)
## I got no clue what to actually call it! Anyways, this is the mod's core node, it handles the partners inputs.
@onready var thingie: PartnerThingie
# Partner intelligence (the bare minimum)
@onready var ledgeDetectionCast := $LedgeDetectionCast
@onready var wallDetectionCast := $WallDetectionCast
@onready var playerFinder := $PlayerFinder
@onready var objFinder := $ObjectsFinder
@onready var objTracker := $ObjectsTracking

var isInsideWall := false
var enemyNearby := false
var onLedge := false
var isPlayerDistantVertically := 0
var willHaveToJump := false
var triesGettingUp := 0
var closeToWall := false
var isTeleporting := false

var afterSomething := false
#endregion

#region Settings Related
var fixedSize := ""
#endregion

func _ready() -> void:
	var oldID = player_id
	add_to_group("CharPartners-Partners")
	
	player_id %= 4
	super()
	
	player_id = oldID
	_ready_super()

func _ready_super() -> void:
	#region Partner related
	var oldID = Global.player_characters[player_id]
	
	match (thingie.PARTNER_PHYSICS):
		0:
			character = "Mario"
			Global.player_characters[player_id] = 0
		1:
			character = CHARACTERS[int(Global.player_characters[player_id])]
		2:
			character = CHARACTERS[int(Global.player_characters[0])]
			Global.player_characters[player_id] = Global.player_characters[0]
	while (Global.player_power_states.length() < player_id + 1):
		Global.player_power_states += "0"
	if (thingie.PARTNER_MUTED >= 1):
		get_node("SkidSFX").volume_db = -80.0
	#endregion
	
	apply_character_physics()
	
	Global.player_characters[player_id] = oldID
	character = CHARACTERS[int(Global.player_characters[player_id])]
	
	if Global.current_level.first_load and Global.current_game_mode == Global.GameMode.MARATHON_PRACTICE:
		Global.player_power_states[player_id] = "0"
	
	var cur_power_state = int(Global.player_power_states[player_id])
	power_state = get_node("PowerStates/" + physics_params("STARTING_POWER_STATE", POWER_PARAMETERS))
	power_state = $PowerStates.get_node(POWER_STATES[cur_power_state])
	
	await get_tree().process_frame
	
	remove_unneeded()
	handle_size_fix()
	set_power_state_frame()
	handle_invincible_palette()

func _process(delta: float) -> void:
	if (isInsideWall && thingie.partnerState != thingie.FollowStage.RESPAWN):
		teleport_player(global_position - Vector2(16, 0), true, "Normal")
	handle_activeness()
	
	super(delta)
	nodes_process(delta)
	handle_power_up_sync()

func remove_unneeded() -> void:
	if (thingie.PARTNER_BEHAVIOR == thingie.FollowBehavior.AGRESSIVE
	|| thingie.PARTNER_BEHAVIOR == thingie.FollowBehavior.GREEDY
	|| thingie.PARTNER_BEHAVIOR == thingie.FollowBehavior.ENEMY):
		return
		
	objFinder.queue_free()
	objTracker.queue_free()

func handle_power_up_sync() -> void:
	if (fixedSize == "Small"
	|| thingie.PARTNER_POWER_EXCLUSIVE):
		return
	if (thingie.leader != null):
		if (thingie.leader.power_state.power_tier > power_state.power_tier):
			if (thingie.isEnemy):
				power_state = get_node("PowerStates/Big")
			else:
				get_power_up(thingie.leader.power_state.state_name, false)
		elif (thingie.leader.power_state.power_tier < power_state.power_tier):
			power_state = get_node("PowerStates/" + thingie.leader.power_state.state_name)

func handle_size_fix() -> void:
	if (thingie.isEnemy):
		await get_tree().process_frame
	match (thingie.PARTNER_PERMANENT_SIZE):
		0:
			return
		1:
			fixedSize = "Small"
		2:
			fixedSize = "Big"
	
	get_power_up(fixedSize, false)

func handle_activeness() -> void:
	if (Global.current_game_mode != Global.GameMode.CUSTOM_LEVEL):
		if thingie.leader == null || ["Dead", "Pipe"].has(thingie.leader.state_machine.get_state()) && state_machine.get_state() == "Normal": 
			process_mode = Node.PROCESS_MODE_DISABLED
		else:
			process_mode = Node.PROCESS_MODE_INHERIT

func nodes_process(delta: float) -> void:
	ai_update_hitbox(thingie.leader)
	
	if !$OnScreen.is_on_screen() && !is_dead:
		if thingie.respawnTime > 0:
			thingie.respawnTime -= delta
		else:
			thingie.partnerState = thingie.FollowStage.RESPAWN
	elif $OnScreen.is_on_screen():
		thingie.respawnTime = thingie.PARTNER_RESPAWN_TIME

func ai_update_hitbox(leader: Player) -> void:
	if (playerFinder != null && leader != null):
		var c = global_position.y - leader.global_position.y
		isPlayerDistantVertically = int(playerFinder.is_colliding() && c > 64 && leader.is_actually_on_floor() && leader.input_direction == 0)
		# I might get confused whe making this, basically sets to 1 or -1 depending on leader's pos.
		isPlayerDistantVertically *= sign(c)
		if (isPlayerDistantVertically == 1):
			willHaveToJump = roundi(global_position.y) > roundi(leader.global_position.y)
		
	if (ledgeDetectionCast != null && is_on_floor()):
		ledgeDetectionCast.floor_normal = get_floor_normal()
		ledgeDetectionCast.position.x = abs(8 + (abs(velocity.x) * 0.1)) * direction
		onLedge = (!ledgeDetectionCast.is_colliding() && input_direction != 0 && !in_water)
	
	if (wallDetectionCast != null):
		wallDetectionCast.floor_normal = get_floor_normal()
		wallDetectionCast.position.x = abs(4) * direction
		wallDetectionCast.target_position.y = abs(8 + (abs(velocity.x) * 0.25)) * direction
		
		if (wallDetectionCast.is_colliding()):
			closeToWall = true
		else:
			if (is_actually_on_floor()):
				closeToWall = false
	
	if (objTracker != null):
		objTracker.scale.x = direction
		
	if (objFinder != null):
		if (objFinder.object == null || abs(objFinder.target_position.x) >= 256 || abs(objFinder.target_position.y) >= 256):
			afterSomething = false

func is_inside_wall(body: Node2D) -> void:
	if (body is TileMapLayer):
		if (!is_actually_on_wall()):
			return
	if (body.get_parent() == thingie.leader.camera_center_joint):
		return
	if (body is not Player):
		isInsideWall = true

func is_outside_wall(_body: Node2D) -> void:
	isInsideWall = false

func on_enemy_nearby(bodyOrArea: Node2D) -> void:
	if (bodyOrArea.owner is Enemy || bodyOrArea is Enemy):
		enemyNearby = true

func on_enemy_left(_bodyOrArea: Node2D) -> void:
	if (enemyNearby):
		enemyNearby = false

# Not only a treasure but it can also be an enemy.
func treasure_found(areaOrBody: Node2D) -> void:
	if (areaOrBody == null):
		return
	
	match (thingie.PARTNER_BEHAVIOR):
		thingie.FollowBehavior.AGRESSIVE:
			if ((areaOrBody is Enemy || areaOrBody.owner is Enemy) 
			&& (areaOrBody is not Projectile || areaOrBody.owner is not Projectile) 
			&& (areaOrBody is not Shell || areaOrBody.owner is not Shell)):
				afterSomething = true
				objFinder.object = areaOrBody
		thingie.FollowBehavior.GREEDY:
			if (areaOrBody.has_method("collect") || (areaOrBody.owner != null && areaOrBody.owner.has_method("collect"))):
				afterSomething = true
				objFinder.object = areaOrBody
			if (areaOrBody is PowerUpItem || areaOrBody.owner is PowerUpItem):
				afterSomething = true
				objFinder.object = areaOrBody
		thingie.FollowBehavior.ENEMY:
			if ((areaOrBody is Player || areaOrBody.owner is Player)
			&& (!thingie.partners.has(areaOrBody) && !thingie.partners.has(areaOrBody.owner))):
				afterSomething = true
		_:
			if (areaOrBody is PowerUpItem || areaOrBody.owner is PowerUpItem):
				afterSomething = true
				objFinder.object = areaOrBody

func die_as_enemy(pit: bool = false, type: String = "") -> void:
	thingie.partnerState = thingie.FollowStage.FOLLOW
	
	if ["Dead", "Pipe", "LevelExit"].has(state_machine.state.name): return
	if type != "": last_damage_source = type if type in valid_death_types else ""
	is_dead = true
	visible = not pit
	
	if (thingie.PARTNER_MUTED >= 1):
		AudioManager.play_sfx("die_sting", global_position)
	
	sprite.process_mode = Node.PROCESS_MODE_ALWAYS
	state_machine.transition_to("Dead", {"Pit": pit})

func stun(newVelocityX := 90 * -direction, newVelocityY := -160, actuallyStun := false) -> void:
	if can_hurt && !is_invincible:
		if (actuallyStun):
			thingie.stunned = true
		velocity = Vector2(newVelocityX, newVelocityY)
		do_i_frames()

#region Non-player fix
func jump() -> void:
	super()
	
	if (thingie.PARTNER_MUTED >= 2):
		AudioManager.kill_sfx(physics_params("JUMP_SFX", COSMETIC_PARAMETERS))

func handle_directions() -> void:
	super()
	
	input_direction = thingie.keyHold[thingie.INPUT.XDIR]
	velocity_direction = sign(velocity.x)

func damage(type: String=""):
	if (power_state.name != "Small" && 
	(thingie.PARTNER_POWER_EXCLUSIVE
	|| thingie.isEnemy
	|| thingie.PARTNER_BEHAVIOR == thingie.FollowBehavior.FREE)):
		super(type)
	else:
		stun()

func do_smoke_effect() -> void:
	super()
	AudioManager.kill_sfx("magic")

func exit_pipe(pipe: PipeArea):
	process_mode = Node.PROCESS_MODE_INHERIT
	super(pipe)
	
func on_area_entered(area: Area2D):
	super(area)
	
	var obj := area.owner
	
	if (thingie.isEnemy):
		if (obj is Player):
			if (!obj.can_hurt || !can_hurt):
				return
			var is_below_player = obj.global_position.y + 8 < global_position.y if obj.gravity_vector.y >= 0 else obj.global_position.y - 8 > global_position.y
			if obj.is_invincible:
				damage()
			elif (obj.actual_velocity_y() >= 15 or is_below_player) and obj.in_water == false:
				stun(0, 160, true)
				obj.enemy_bounce_off(false, false)
			elif (!thingie.partners.has(obj) && thingie.damagesPlayer):
				obj.damage()

#region Replacements
func bump_ceiling() -> void:
	if (thingie.PARTNER_MUTED <= 0):
		AudioManager.play_sfx("bump", global_position)
	velocity.y = sign(gravity_vector.y) * physics_params("CEILING_BUMP_SPEED")
	can_bump_sfx = false
	bumping = true
	await get_tree().create_timer(0.1).timeout
	if (thingie.PARTNER_MUTED <= 0):
		AudioManager.kill_sfx(physics_params("JUMP_SFX", COSMETIC_PARAMETERS))
	await get_tree().create_timer(0.1).timeout
	bumping = false

func teleport_player(new_position := Vector2.ZERO, instant := false, old_state = state_machine.state.name) -> void:
	if (isTeleporting): 
		return
	isTeleporting = true
	if (!instant):
		hide()
		do_smoke_effect()
		state_machine.transition_to("Freeze")
		await get_tree().create_timer(1.0, false).timeout
		global_position = new_position
		velocity.y = 0
		
		show()
		do_smoke_effect()
		state_machine.transition_to(old_state)
	else:
		state_machine.transition_to("Freeze")
		
		global_position = new_position
		velocity.y = 0
		
		do_smoke_effect()
		state_machine.transition_to(old_state)
	isTeleporting = false

func power_up_animation(new_power_state := "") -> void:
	if normal_state.jump_buffer > 0:
		normal_state.jump_buffer += 10

	var old_frames = sprite.sprite_frames
	var new_frames = $ResourceSetterNew.get_resource(load(get_character_sprite_path(new_power_state)))
	var old_state = power_state
	var new_state = get_node("PowerStates/" + new_power_state)
	
	process_mode = Node.PROCESS_MODE_DISABLED
	sprite.process_mode = Node.PROCESS_MODE_ALWAYS
	sprite.show()
	
	var hitbox_changed = new_state.power_tier != old_state.power_tier
	var shrinking = hitbox_changed and (new_state.power_tier < old_state.power_tier)
	var can_powerup_jump = Global.player_action_pressed("jump", player_id) == false
	var anim_name := ""
	if old_state.state_name != "Small" and new_power_state != "Small":
		if %Sprite.sprite_frames.has_animation(new_power_state + "Grow"): # SkyanUltra: Optional check for animations for going from Big to Fire-equivalent power states.
			anim_name = new_power_state + "Shrink" if shrinking else new_power_state + "Grow"
		else: anim_name = ""
	else:
		anim_name = "Shrink" if shrinking else "Grow"
	handle_invincible_palette()
	if hitbox_changed and anim_name != "":
		if Settings.file.visuals.transform_style == 0:
			sprite.speed_scale = 3
			play_animation(anim_name)
			
			var rainbow = physics_params("RAINBOW_POWERUP_FX", COSMETIC_PARAMETERS, new_power_state) or physics_params("RAINBOW_POWERUP_FX", COSMETIC_PARAMETERS, old_state.state_name)
			if rainbow:
				transforming = true
				sprite.material.set_shader_parameter("enabled", true)
			
			await get_tree().create_timer(0.4, true).timeout
			power_state = new_state
			sprite.sprite_frames = new_frames
			handle_invincible_palette()
			play_animation(anim_name, true)
			await get_tree().create_timer(0.4, true).timeout
			
			if rainbow:
				sprite.material.set_shader_parameter("enabled", false)
			transforming = false
		else:
			sprite.speed_scale = 0
			if shrinking:
				%GrowAnimation.play(anim_name)
			else:
				sprite.sprite_frames = new_frames
				%GrowAnimation.play(anim_name)
			await get_tree().create_timer(0.8, true).timeout
			sprite.sprite_frames = new_frames
			transforming = false
	else:
		if Settings.file.visuals.transform_style == 1:
			for i in 6:
				sprite.sprite_frames = new_frames
				await get_tree().create_timer(0.05).timeout
				sprite.sprite_frames = old_frames
				await get_tree().create_timer(0.05).timeout
		else:
			var rainbow = physics_params("RAINBOW_POWERUP_FX", COSMETIC_PARAMETERS, new_power_state) or physics_params("RAINBOW_POWERUP_FX", COSMETIC_PARAMETERS, old_state.state_name)
			if rainbow:
				transforming = true
				sprite.material.set_shader_parameter("enabled", true)
			handle_invincible_palette()
			sprite.stop()
			await get_tree().create_timer(0.6).timeout
			transforming = false
			if rainbow:
				sprite.material.set_shader_parameter("enabled", false)
	sprite.play("Idle")
	sprite.process_mode = Node.PROCESS_MODE_INHERIT
	process_mode = Node.PROCESS_MODE_INHERIT
	if Global.player_action_pressed("jump", player_id) and can_powerup_jump:
		jump()
#endregion

#region Do nothing actually!
func enter_pipe(_pipe: PipeArea, _warp_to_level := true) -> void:
	return

func die(_pit: bool=false, _type: String=""):
	return

func recenter_camera() -> void:
	return
	
func camera_make_current() -> void:
	return

func apply_character_sfx_map() -> void:
	return

func reset_camera_to_center() -> void:
	return
	
func death_load() -> void:
	return
#endregion
#endregion
