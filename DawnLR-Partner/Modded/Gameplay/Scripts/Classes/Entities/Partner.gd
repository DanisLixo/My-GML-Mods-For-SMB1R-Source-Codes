class_name Partner extends Player

#region Partner shit (a lot is from Sonic Worlds Next and my gmSMB mod)
## I got no clue what to actually call it! Anyways, this is the mod's core node, it handles the partners inputs.
@onready var thingie: Node
# Partner intelligence (the bare minimum)
@onready var ledgeDetectionCast := $LedgeDetectionCast
@onready var wallDetectionCast := $WallDetectionCast
@onready var playerFinder := $PlayerFinder
@onready var objFinder := $ObjectsFinder
@onready var groundFinder := $GroundFinder
@onready var objTracker := $ObjectsTracking

var isInsideWall := false
var enemyNearby := false
var onLedge := false
var isPlayerDistantVertically := 0
var willHaveToJump := false
var triesGettingUp := 0
var closeToWall := false
var isTeleporting := false
var overFloor := false
var afterSomething := false
#endregion

#region Settings Related
var fixedSize := ""
#endregion

func _ready() -> void:
	var oldID = player_id
	add_to_group("Players-AI")
	
	player_id %= 4
	super()
	
	player_id = oldID
	thingie.set_config()
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
		teleport_player(global_position + (Vector2(16, 0) * sign(global_position.x - thingie.leader.global_position.x)), true, "Normal")
	handle_activeness()
	
	super(delta)
	nodes_process(delta)
	handle_power_up_sync()

func remove_unneeded() -> void:
	if (thingie.PARTNER_BEHAVIOR == thingie.FollowBehavior.AGRESSIVE
	|| thingie.PARTNER_BEHAVIOR == thingie.FollowBehavior.GREEDY
	|| thingie.PARTNER_BEHAVIOR == thingie.FollowBehavior.ENEMY):
		return

	if (objFinder != null):
		objFinder.queue_free()
	if (objTracker != null):
		objTracker.queue_free()

func handle_power_up_sync() -> void:
	if (fixedSize == "Small"
	|| thingie.PARTNER_POWER_EXCLUSIVE):
		return
	
	if (!thingie.isEnemy):
		if (fixedSize == "Small" && power_state.name == "Big"):
			power_state = get_node("PowerStates/Small")
			return
		if (fixedSize == "Big" && power_state.name == "Small"):
			power_state = get_node("PowerStates/Big")
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
		ledgeDetectionCast.position.x = clamp(ledgeDetectionCast.position.x, -24, 24)
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
	
	if (groundFinder != null):
		overFloor = groundFinder.is_colliding()
		
	if (objFinder != null):
		afterSomething = !(objFinder.object == null || abs(objFinder.target_position.x) >= 256 || abs(objFinder.target_position.y) >= 256)
	
	if (!afterSomething):
		fire_only = false

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

func on_enemy_nearby(areaOrBody: Node2D) -> void:
	var entity := areaOrBody if (areaOrBody != Area2D && areaOrBody == areaOrBody.owner) else areaOrBody.owner
	
	if (entity is Enemy):
		enemyNearby = true

func on_enemy_left(_bodyOrArea: Node2D) -> void:
	if (enemyNearby):
		enemyNearby = false

var fire_only_enemies := ["spiny", "piranha", "barrel", "bowser", "fighterfly", "spiny", "truebowser"]
var unkillable_enemies := ["drybones", "boo", "chainchomp", "muncher", "podoboo", "thromp"]
var fire_only := false
# Not only a treasure but it can also be an enemy.
func treasure_found(areaOrBody: Node2D) -> void:
	if (areaOrBody == null):
		return
	
	var entity := areaOrBody if (areaOrBody.owner == null || areaOrBody != Area2D && areaOrBody == areaOrBody.owner) else areaOrBody.owner
	
	match (thingie.PARTNER_BEHAVIOR):
		thingie.FollowBehavior.AGRESSIVE:
			var obj_id := entity.scene_file_path.get_file().get_basename().to_lower()
			if (entity is Enemy 
			&& entity is not Projectile
			&& entity is not Shell
			&& unkillable_enemies.has(obj_id)):
				if (in_water || fire_only_enemies.has(obj_id)):
					fire_only = true
				afterSomething = true
				objFinder.object = entity
			elif (afterSomething):
				afterSomething = false
		thingie.FollowBehavior.GREEDY:
			if (entity.has_method("collect") || (entity.has_method("collect"))):
				afterSomething = true
				objFinder.object = entity
			if (entity is PowerUpItem):
				afterSomething = true
				objFinder.object = entity
		thingie.FollowBehavior.ENEMY:
			if ((entity is Player)
			&& (!thingie.partners.has(entity))):
				afterSomething = true
		_:
			if (entity is PowerUpItem):
				afterSomething = true
				objFinder.object = entity

func die_as_enemy(pit: bool = false, type: String = "") -> void:
	thingie.partnerState = thingie.FollowStage.FOLLOW
	
	if ["Dead", "Pipe", "LevelExit"].has(state_machine.state.name): return
	if type != "": last_damage_source = type if type in valid_death_types else ""
	is_dead = true
	visible = not pit
	
	AudioManager.play_sfx("die_sting", global_position)
	
	sprite.process_mode = Node.PROCESS_MODE_ALWAYS
	state_machine.transition_to("Dead", {"Pit": pit})

func stun(newVelocityX := 90 * -direction, newVelocityY := -160, actuallyStun := false) -> void:
	if can_hurt && !is_invincible:
		if (actuallyStun):
			thingie.stunned = true
		velocity = Vector2(newVelocityX, newVelocityY)
		do_i_frames()
	if (thingie.stunned):
		play_animation("Crouch")
		thingie.p_reset_inputs()
		await get_tree().create_timer(1.0).timeout
		thingie.stunned = false

#region Non-player fix

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
	
	if (obj is Vine && thingie.leader.state_machine.get_state() == "Climb"):
		thingie.keyHold[thingie.INPUT.YDIR] = -1
	
	if (obj is Player):
		if (player_id < obj.player_id):
			thingie.keyHold[thingie.INPUT.XDIR] = -1
		else:
			thingie.keyHold[thingie.INPUT.XDIR] = 1
	
	if (thingie.isEnemy):
		if (obj is Player):
			if (!obj.can_hurt || !can_hurt):
				return
			var is_below_player = obj.global_position.y + 8 < global_position.y if obj.gravity_vector.y >= 0 else obj.global_position.y - 8 > global_position.y
			if obj.is_invincible:
				damage()
			elif (obj.actual_velocity_y() >= 15 or is_below_player) and obj.in_water == false:
				if (thingie.spawned):
					stun(0, 160, true)
					obj.enemy_bounce_off(false, false)
			elif (!thingie.partners.has(obj) && thingie.damagesPlayer):
				obj.damage()

#region Replacements
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

var apply := false
func apply_character_physics():
	if (!apply):
		apply = true
		return 
	super()

func super_star():
	if (get_node_or_null("CanvasLayer/Control2/MarginContainer/Timers/StarTimer/TimerSprite") == null):
		oh_shit()
	super()

class nothing extends Node:
	var max_value := 0.0

func oh_shit() -> void:
	var node_path := ["CanvasLayer", "Control2", "MarginContainer", "Timers", "StarTimer", "TimerSprite"]
	var parent_node: Node = self
	for i in node_path.size():
		var node: Node
		if (node_path[i] == node_path.back()):
			node = nothing.new()
		else:
			node = Node.new()
		node.name = node_path[i]
		
		parent_node.add_child(node)
		parent_node = node
#endregion

#region Do nothing actually!
func enter_pipe(pipe: PipeArea, _warp_to_level: =true, _wait_forever: =false) -> void:
	pipe.can_enter = true

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
