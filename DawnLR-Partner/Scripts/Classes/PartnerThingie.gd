class_name PartnerThingie
extends Node

# Options
const partnerScene := preload("res://mods-unpacked/DawnLR-Partner/Scenes/Prefabs/Entities/Partner.tscn")
const partnerSimpleScene := preload("res://mods-unpacked/DawnLR-Partner/Scenes/Prefabs/Entities/PartnerSprite.tscn")
const bubbleScene := preload("res://mods-unpacked/DawnLR-Partner/Scenes/Bubble.tscn")

# Global (Both use)
var partners: Array = []
# Partner Inputing help
enum INPUT {XDIR, YDIR, JUMP, RUN, ACTION}
var keyPress := [0,0,0,0,0]
var keyHold := [0,0,0,0,0]
var keyRelease := [0,0,0,0,0]
# Copy movement stuff
enum MOVE {POS, DIR, ANIM, POWER, ACTPRESS}
var moves := [Vector2(-99999999, -99999999), 1, "Spawning", "0", false]
var intendedAnim := ""
var playerOverride := ""

var damagesPlayer := false
var spawning := false
var spawned := false
var isEnemy := false
var stunned := false

#region Partner shit (a lot is from Sonic Worlds Next and my gmSMB mod)
@onready var player = get_parent()
# Partner setup.
var leader: Player
# Respawn if they're lost.
var respawnTime := 0.0
var spawnTime := 0.0
# Input memory from player to the partner to replicate, it will only work if they're being able to follow you.
var inputMemoryPress = []
var inputMemoryHold = []
var inputMemoryRelease = []
# Movement memory from player to the partner to replicate.
var inputMemoryMovement = []
# Memory track so they grab what the leader did and reproduce.
var memoryPosition := 0
var INPUT_MEMORY_LENGTH := 0

# MISC
var algorithmOverride := "Copy"
var flagpole
#endregion

#region SettingsVariables
# Partner setup.
enum FollowStyle {
	CPU, COPY
}
enum FollowStage {
	FOLLOW, RETURN, RESPAWN
}
enum FollowBehavior {
	NORMAL, ENEMY,
	AGRESSIVE, GREEDY, 
	FREE
}

@onready var PartnerSettings := get_node("/root/ModLoader/DawnLR-Partner/PartnerSettingsManager") 

var PARTNER_STYLE := FollowStyle.CPU
var PARTNER_BEHAVIOR := FollowBehavior.NORMAL
var PARTNER_PERMANENT_SIZE = 0
var PARTNER_MUTED := 0
var PARTNER_POWER_EXCLUSIVE := 0
var PARTNER_PHYSICS := 0
var PARTNER_RESPAWN_TIME := 5.0
var PARTNER_ENEMY_SPAWN_TIME := 5.0

var partnerState := FollowStage.FOLLOW
#endregion

func _ready() -> void:
	await player.ready
	INPUT_MEMORY_LENGTH = 10 * Global.player_characters.size() 
	
	if (is_leader()):
		leader_ready()
	elif (leader != null):
		partner_ready()
	else:
		printerr("There's a bug with the Partners Mod! Something made the leader be null to the partner with ID: " + str(player.player_id) + "!")
		printerr("If the informed ID is 0, that means that the player's leader is not set to himself!")
		assert(leader != null, "Leader Node is not set! A partner is broken!")

func _process(delta: float) -> void:
	if (is_leader()):
		if (inputMemoryPress.size() != 0 || inputMemoryMovement.size() != 0):
			leader_process(delta)
	elif (leader != null):
		if (leader.get_meta("PartnerMod").inputMemoryPress.size() != 0 || leader.get_meta("PartnerMod").inputMemoryMovement.size() != 0):
			partner_process(delta)

func _physics_process(delta: float) -> void:
	if (is_leader()):
		leader_physics_process(delta)

func is_leader() -> bool:
	return player == get_tree().get_first_node_in_group("Players")

func throw_projective_with_thingie() -> void:
	player.attacked.emit()
	player.projectile_type = load(player.physics_params("PROJ_TYPE", player.POWER_PARAMETERS) + ".tscn")
	var node = player.projectile_type.instantiate()
	var offset = player.physics_params("PROJ_OFFSET", player.POWER_PARAMETERS)
	var angle = Vector2.ZERO if player.physics_params("PROJ_ANGLE", player.POWER_PARAMETERS) == null else Vector2.from_angle(deg_to_rad(player.physics_params("PROJ_ANGLE", player.POWER_PARAMETERS)))
	var speed = player.physics_params("PROJ_SPEED", player.POWER_PARAMETERS)
	
	speed = player.calculate_angle_param("PROJ_SPEED")
	
	var speed_scaling = 0
	if player.physics_params("PROJ_SPEED_SCALING", player.POWER_PARAMETERS):
		speed_scaling = player.velocity.x * player.direction
	
	node.global_position = player.global_position - Vector2(offset[0] * player.direction, offset[1] * player.gravity_vector.y)
	if "direction" in node: node.direction = player.direction
	if "velocity" in node: node.velocity = Vector2((speed[0] + speed_scaling) * player.direction, -speed[1])
	if node is Projectile:
		node.set_meta("player", player) # One fucking line.
		node.is_friendly = true
		if "character" in node:
			node.character = player.character
		node.PARTICLE = load(player.physics_params("PROJ_PARTICLE", player.POWER_PARAMETERS) + ".tscn")
		for param in player.POWER_PARAM_LIST:
			node.set(param, player.physics_params(player.POWER_PARAM_LIST[param], player.POWER_PARAMETERS))
		node.MOVE_SPEED = speed[0] + speed_scaling
		node.MOVE_ANGLE = angle
	player.call_deferred("add_sibling", node)
	if not (player.is_on_floor() or player.in_water):
		player.projectiles_fired_since_left_ground += 1
	player.projectile_amount += 1
	node.tree_exited.connect(func(): player.projectile_amount -= 1)
	AudioManager.play_sfx(player.physics_params("PROJ_SFX_THROW", player.POWER_PARAMETERS), player.global_position)
	player.attacking = true
	await player.get_tree().create_timer(0.1, false).timeout
	player.attacking = false

#region Leader Functions
func leader_ready() -> void:
	if [Global.GameMode.MARATHON, Global.GameMode.MARATHON_PRACTICE, Global.GameMode.LEVEL_EDITOR].has(Global.current_game_mode):
		queue_free()
		return
	for _i in range(INPUT_MEMORY_LENGTH):
		if (PartnerSettings.file.selector.follow_mode == FollowStyle.CPU):
			inputMemoryPress.append(keyPress.duplicate(true))
			inputMemoryHold.append(keyHold.duplicate(true))
			inputMemoryRelease.append(keyRelease.duplicate(true))
		else:
			inputMemoryMovement.append(moves.duplicate(true))
	
	await get_tree().process_frame
	add_partners()

func leader_process(delta: float) -> void:
	memoryPosition = memoryPosition % INPUT_MEMORY_LENGTH
	
	if (PartnerSettings.file.selector.follow_mode == FollowStyle.CPU):
		for i in range(keyPress.size()):
			inputMemoryPress[memoryPosition][i] = keyPress[i]
			inputMemoryHold[memoryPosition][i] = keyHold[i]
			inputMemoryRelease[memoryPosition][i] = keyRelease[i]
	else: 
		for i in range(moves.size()):
			inputMemoryMovement[memoryPosition][i] = moves[i]
	
	memoryPosition += 1

func leader_physics_process(_delta: float):
	if (PartnerSettings.file.selector.follow_mode == FollowStyle.CPU):
		handle_input()
	else: 
		handle_movement()

func add_partners() -> void:
	for i in Global.player_characters.size():
		if i != 0 && Global.player_characters[i] != -1:
			var curPartner = set_partner_by_id(i)
			if (!curPartner.is_node_ready()):
				await curPartner.ready
			curPartner.thingie.leader = player
	find_my_partners()

func set_partner_by_id(i: int) -> Node2D:
	var curPartner
	# Global.connected_players += 1
	if (PartnerSettings.file.selector.follow_mode == FollowStyle.COPY):
		curPartner = partnerSimpleScene.instantiate()
		
		curPartner.player_id = i
		curPartner.z_index = player.z_index - 1
		curPartner.global_position = player.global_position
		player.call_deferred("add_sibling", curPartner)
	else:
		curPartner = partnerScene.instantiate()
		
		curPartner.player_id = i
		curPartner.z_index = player.z_index - 1
		curPartner.global_position = player.global_position
		player.call_deferred("add_sibling", curPartner)
	
	return curPartner
## Used only by the leader, it needs to be set so partners can use it.
func handle_input() -> void:
	var player_id = player.player_id
	# Hell yeah
	keyPress[INPUT.XDIR] = int(Global.player_action_just_pressed("move_right", player_id)) - int(Global.player_action_just_pressed("move_left", player_id))
	keyPress[INPUT.YDIR] = int(Global.player_action_just_pressed("move_down", player_id)) - int(Global.player_action_just_pressed("move_up", player_id))
	keyPress[INPUT.JUMP] = Global.player_action_just_pressed("jump", player_id)
	keyPress[INPUT.ACTION] = Global.player_action_just_pressed("action", player_id)
	keyPress[INPUT.RUN] = Global.player_action_just_pressed("run", player_id)
	
	keyRelease[INPUT.XDIR] = int(Global.player_action_just_released("move_right", player_id)) - int(Global.player_action_just_released("move_left", player_id))
	keyRelease[INPUT.YDIR] = int(Global.player_action_just_released("move_down", player_id)) - int(Global.player_action_just_released("move_up", player_id))
	keyRelease[INPUT.JUMP] = Global.player_action_just_released("jump", player_id)
	keyRelease[INPUT.ACTION] = Global.player_action_just_released("action", player_id)
	keyRelease[INPUT.RUN] = Global.player_action_just_released("run", player_id)
	
	keyHold[INPUT.XDIR] = int(Global.player_action_pressed("move_right", player_id)) - int(Global.player_action_pressed("move_left", player_id))
	keyHold[INPUT.YDIR] = int(Global.player_action_pressed("move_down", player_id)) - int(Global.player_action_pressed("move_up", player_id))
	keyHold[INPUT.JUMP] = Global.player_action_pressed("jump", player_id)
	keyHold[INPUT.ACTION] = Global.player_action_pressed("action", player_id)
	keyHold[INPUT.RUN] = Global.player_action_pressed("run", player_id)
	
func handle_movement() -> void:
	moves[MOVE.POS] = player.global_position
	moves[MOVE.DIR] = player.direction
	moves[MOVE.ANIM] = get_intended_animation()
	moves[MOVE.POWER] = player.power_state.name
	moves[MOVE.ACTPRESS] = Global.player_action_just_pressed("action", 0)
	
var old_power_state := ""
var new_power_state := ""
func get_intended_animation() -> String:
	if (playerOverride.contains("Grow") || playerOverride.contains("Shrink") || playerOverride == "PowerUp"):
		var old_state = player.get_node("PowerStates/" + old_power_state)
		var new_state = player.get_node("PowerStates/" + new_power_state)
		var hitbox_changed = new_state.power_tier != old_state.power_tier
		var shrinking = hitbox_changed and (new_state.power_tier < old_state.power_tier)
		var anim_name := ""
		if old_state.state_name != "Small" and new_power_state != "Small":
			anim_name = new_power_state + "Shrink" if shrinking else new_power_state + "Grow"
		else:
			anim_name = "Shrink" if shrinking else "Grow"
		
		if (!hitbox_changed || Settings.file.visuals.transform_style == 1):
			anim_name = "NO SPRITE!"
		
		playerOverride = "null"
		return anim_name
	
	return intendedAnim
#endregion

#region Partner Functions

func partner_ready() -> void:
	set_config()
	if (PARTNER_BEHAVIOR != FollowBehavior.FREE):
		find_my_partners()
	
	if (PARTNER_BEHAVIOR == FollowBehavior.FREE
	|| isEnemy):
		flagpole = get_tree().get_first_node_in_group("Flagpole")
		if (flagpole is not Node2D):
			flagpole = get_tree().get_first_node_in_group("CastleNPCs")
		if (PARTNER_BEHAVIOR == FollowBehavior.ENEMY):
			player.global_position -= Vector2(16, 16)
	
	var guys = 0
	for i in Settings.file.game.characters:
		if (i != -1):
			guys += 1
	memoryPosition = INPUT_MEMORY_LENGTH - (INPUT_MEMORY_LENGTH / float(guys)) * player.player_id * 0.8
	
	handle_spawning(0)

func partner_process(delta: float) -> void:
	memoryPosition = memoryPosition % INPUT_MEMORY_LENGTH
	
	if (PARTNER_STYLE == FollowStyle.CPU):
		handle_computer_input(delta)
	else:
		handle_computer_movement(delta)
	
	if (spawning && !spawned):
		handle_spawning(delta)
		return

func find_my_partners():
	if (!isEnemy && !is_leader()):
		partners.push_front(leader)
		
	var arr = get_tree().get_nodes_in_group("CharPartners-Partners")
	for i in arr.size():
		var partner = arr[i - 1]
		if (partner != player):
			if (PartnerSettings.file.selector.behavior[i + 1] == FollowBehavior.FREE):
				continue
			
			if (isEnemy && PartnerSettings.file.selector.behavior[i + 1] == FollowBehavior.ENEMY):
				partners.push_front(partner)
			elif (!isEnemy && PartnerSettings.file.selector.behavior[i + 1] != FollowBehavior.ENEMY):
				partners.push_front(partner)

func set_config() -> void:
	var options: Dictionary = PartnerSettings.file.cpu_options
	if (PartnerSettings.file.selector.follow_mode == FollowStyle.COPY):
		options = PartnerSettings.file.copy_options
		PARTNER_STYLE = FollowStyle.COPY
	
	PARTNER_BEHAVIOR = int(PartnerSettings.file.selector.behavior[player.player_id]) as FollowBehavior
	PARTNER_ENEMY_SPAWN_TIME = PartnerSettings.file.selector.enemy_spawn_delay
	
	PARTNER_PERMANENT_SIZE = options.permanent_size
	PARTNER_MUTED = options.muted
	
	if (PARTNER_STYLE == FollowStyle.COPY):
		return
	
	PARTNER_POWER_EXCLUSIVE = options.power_up_exclusivity
	PARTNER_PHYSICS = options.apply_physics
	PARTNER_RESPAWN_TIME = options.respawn_time
	
	match (PARTNER_BEHAVIOR):
		FollowBehavior.ENEMY:
			spawnTime = PARTNER_RESPAWN_TIME
			PARTNER_PERMANENT_SIZE = 2 # That means big.
			PARTNER_POWER_EXCLUSIVE = 1 # Yes only himself get the prize.
			isEnemy = true
			
			player.handle_power_up_sync()
		FollowBehavior.FREE:
			PARTNER_POWER_EXCLUSIVE = 1 # Yes only himself get the prize.
	
	respawnTime = PARTNER_RESPAWN_TIME

func handle_computer_input(_delta: float) -> void:
	algorithmOverride = "AI"
	
	match PARTNER_BEHAVIOR:
		FollowBehavior.NORMAL:
			global_movement()
		FollowBehavior.AGRESSIVE:
			finder_movement()
			global_movement(!player.afterSomething, !player.afterSomething)
		FollowBehavior.GREEDY:
			finder_movement()
			global_movement(!player.afterSomething, !player.afterSomething)
		FollowBehavior.FREE:
			free_movement()
		FollowBehavior.ENEMY:
			if (stunned):
				player.sprite.play("Crouch")
				reset_inputs()
				await get_tree().create_timer(1.0).timeout
				stunned = false
				return
			enemy_movement()
			
	if (!spawning):
		memoryPosition += 1

func handle_respawn(mode := "global") -> void:
	if (partnerState != FollowStage.RESPAWN):
		return
	if (mode != ""):
		player.direction = leader.direction
		respawnTime = PARTNER_RESPAWN_TIME
		partnerState = FollowStage.FOLLOW
	
	if (mode == "global"):
		player.teleport_player(leader.global_position - Vector2(24 * leader.direction, 0), true, "Normal")
	elif (mode == "enemy"):
		if (player.global_position.y >= 256):
			player.teleport_player(leader.global_position - Vector2(48, 32), true, "Normal")
		
	print("State changed to RESPAWN for Partner with ID: " + str(player.player_id))

var bubble: Node2D
func spawn() -> void:
	player.global_position = Vector2(-219, -83)
	player.state_machine.transition_to("Freeze")
	player.sprite.play("Jump")
	
	bubble = bubbleScene.instantiate()
	bubble.thingie = self
	add_sibling(bubble)
	bubble.position.y = -16
	
	%SpawnTimeLabel.timer = self
	%SpawnTimeSprite.node = self
	
	spawnTime = PARTNER_ENEMY_SPAWN_TIME
	spawning = true

func handle_spawning(delta: float) -> void:
	if (!isEnemy):
		spawned = true
		return
	if (!spawning && spawnTime > 0.0):
		spawn()
		return
	
	player.sprite.play("Jump")
	bubble.scale *= Vector2(1.5, 1.5)
	
	if (spawnTime > 0.0):
		spawnTime -= delta
	else:
		player.state_machine.transition_to("Normal")
		bubble.queue_free()
		spawning = false
		spawned = true
		damagesPlayer = true

func computer_jump(conditionPress: bool = player.is_actually_on_floor(), conditionHold := true, undoIfFalse := true) -> void:
	if (conditionPress): keyPress[INPUT.JUMP] = true
	elif (undoIfFalse): keyPress[INPUT.JUMP] = false
	if (conditionHold): keyHold[INPUT.JUMP] = true
	elif (undoIfFalse): keyHold[INPUT.JUMP] = false

func reset_inputs() -> void:
	keyPress[INPUT.XDIR] = 0
	keyPress[INPUT.YDIR] = 0
	keyPress[INPUT.JUMP] = false
	keyPress[INPUT.ACTION] = false
	keyPress[INPUT.RUN] = false
	
	keyRelease[INPUT.XDIR] = 0
	keyRelease[INPUT.YDIR] = 0
	keyRelease[INPUT.JUMP] = false
	keyRelease[INPUT.ACTION] = false
	keyRelease[INPUT.RUN] = false
	
	keyHold[INPUT.XDIR] = 0
	keyHold[INPUT.YDIR] = 0
	keyHold[INPUT.JUMP] = false
	keyHold[INPUT.ACTION] = false
	keyHold[INPUT.RUN] = false

func finder_movement() -> void:
	if (!player.afterSomething):
		return
	
	var distanceToTarget = player.objFinder.target_position
	var isOverMe = distanceToTarget.y < -16
	var isUnderMe = distanceToTarget.y > 16
	
	keyHold[INPUT.XDIR] = sign(distanceToTarget.x)
	keyHold[INPUT.RUN] = (abs(distanceToTarget.x) > 48)
	
	# Wall close to them? No problem!
	if (player.closeToWall && !player.in_water):
		algorithmOverride += " + Close to Wall"
		computer_jump()
	# We gotta go higher. Unless we are not near ground.
	if (player.in_water && player.velocity.y >= 0 
	&& (abs(distanceToTarget.x) > 64 || abs(roundi(distanceToTarget.y)) >= 48) 
	&& !player.ledgeDetectionCast.is_colliding() && !player.closeToWall 
	&& abs(distanceToTarget.x) > (32 * player.player_id)):
		algorithmOverride += " + Water Swimming"
		
		keyPress[INPUT.JUMP] = leader.global_position.y > player.global_position.y
	
	if (abs(distanceToTarget.x) < 56):
		computer_jump(isOverMe, !isUnderMe)

var playerIsFar := false
func free_movement(distanceToLeader: Vector2 = -player.playerFinder.target_position) -> void:
	reset_inputs()
	
	if (flagpole == null || flagpole is not Node2D):
		PARTNER_BEHAVIOR = FollowBehavior.NORMAL
		return
		
	if (partnerState == FollowStage.RESPAWN && player.global_position.y >= 256):
		print("State changed to RESPAWN for Partner with ID: " + str(player.player_id))
		
		player.teleport_player(leader.global_position - Vector2(24 * leader.direction, 0), true, "Normal")
		player.direction = leader.direction
		respawnTime = PARTNER_RESPAWN_TIME
		partnerState = FollowStage.FOLLOW
	if (abs(distanceToLeader.x) > 960):
		playerIsFar = true
	
	if (playerIsFar):
		global_movement(false, false)
		
		if (abs(distanceToLeader.x) < 64):
			playerIsFar = false
		return
	
	var distanceToEnd = player.global_position - flagpole.global_position
	
	keyHold[INPUT.RUN] = (player.is_actually_on_floor() || abs(distanceToEnd.x) <= 256)
	
	keyHold[INPUT.YDIR] = 0
	keyHold[INPUT.XDIR] = -sign(distanceToEnd.x)
	if (player.closeToWall):
		computer_jump()
	if (player.in_water && player.velocity.y >= 0 && !player.ledgeDetectionCast.is_colliding()):
		keyPress[INPUT.JUMP] = true
	
	global_movement(false, false)

func enemy_movement() -> void:
	if (flagpole == null):
		global_movement(false, true)
		return
		
	var distanceToEnd = player.global_position - flagpole.global_position
	
	if (abs(distanceToEnd.x) <= 512):
		keyHold[INPUT.YDIR] = 0
		keyHold[INPUT.XDIR] = -sign(distanceToEnd.x)
		if (player.closeToWall):
			computer_jump()
		if (player.in_water && player.velocity.y >= 0 && !player.ledgeDetectionCast.is_colliding()):
			keyPress[INPUT.JUMP] = true
		
		if abs(distanceToEnd.x) > 96:
			keyHold[INPUT.RUN] = true
	else:
		global_movement(false, true)
		if (player.afterSomething):
			throw_fire()
	
	handle_respawn("enemy")

func throw_fire() -> void:
	keyPress[INPUT.ACTION] = true
	await get_tree().create_timer(0.1).timeout
	keyPress[INPUT.ACTION] = false
	await get_tree().create_timer(0.3).timeout

func global_movement(copyLeader := true, trackLeader := true) -> void:
	var distanceToLeader = -player.playerFinder.target_position
	
	if (copyLeader && leader.state_machine.get_state() != "Pipe"):
		algorithmOverride += " + Copy"
		
		keyPress = leader.get_meta("PartnerMod").inputMemoryPress[memoryPosition].duplicate()
		keyHold = leader.get_meta("PartnerMod").inputMemoryHold[memoryPosition].duplicate()
		keyRelease = leader.get_meta("PartnerMod").inputMemoryRelease[memoryPosition].duplicate()
	
	# ENEMY NEARBY! WE'LL HAVE TO JUMP (if in the ground, of course)!
	if (player.enemyNearby && !player.is_invincible):
		algorithmOverride += " + Enemy Nearby"
		if (player.power_state.power_tier > 1):
			keyPress[INPUT.ACTION] = true
		computer_jump()
	# OH NO! A PIT, QUICK WE HAVE TO JUMP (if in the ground, of course)!
	if (player.onLedge):
		algorithmOverride += " + On Ledge"
		computer_jump((player.is_actually_on_floor() && abs(distanceToLeader.x) > 48))
	# OH LORD! A SPRI- err ok you got the idea.
	if (player.spring_bouncing):
		algorithmOverride += " + Spring Bouncing"
		computer_jump(true)
	
	if (trackLeader):
		handle_stage_movement(distanceToLeader)
	
	if (PARTNER_BEHAVIOR != FollowBehavior.FREE
	&& !isEnemy):
		handle_respawn()

func handle_stage_movement(distanceToLeader: Vector2 = -player.playerFinder.target_position) -> void:
	match partnerState:
		# Near to leader, no sweat.
		FollowStage.FOLLOW:
			keyHold[INPUT.RUN] = true
			
			var distance = (32 * player.player_id)
			if (isEnemy):
				distance = 0
			# X distance difference check, try to go to the partner
			if (abs(distanceToLeader.x) > distance
			|| player.in_water && abs(roundi(distanceToLeader.y)) >= 48):
				algorithmOverride += " + Far Away"
				keyHold[INPUT.XDIR] = -sign(distanceToLeader.x)
				
				computer_jump(
					(roundi(distanceToLeader.y) >= 16 && abs(distanceToLeader.x) < 48), 
					(roundi(distanceToLeader.y) >= 8 && abs(distanceToLeader.x) < 48), false)
				
				# Wall close to them? No problem!
				if (player.closeToWall && !player.in_water):
					algorithmOverride += " + Close to Wall"
					computer_jump()
				# We gotta go higher. Unless we are not near ground.
				if (player.in_water && player.velocity.y >= 0 
				&& (abs(distanceToLeader.x) > 64 || abs(roundi(distanceToLeader.y)) >= 48) 
				&& !player.ledgeDetectionCast.is_colliding() && !player.closeToWall 
				&& abs(distanceToLeader.x) > (32 * player.player_id)):
					algorithmOverride += " + Water Swimming"
					
					keyPress[INPUT.JUMP] = leader.global_position.y > player.global_position.y
			else:
				# They are close to leader. Reset our tries, mission accomplished!
				if (leader.input_direction != 0):
					player.triesGettingUp = 0
			
			if (!isEnemy):
				# Try to go to the partner's back
				var posBehindPlayer = distanceToLeader.x - (8 * (player.player_id - 1)) * -leader.direction
				if (sign(posBehindPlayer * leader.direction) > 0 
				&& abs(distanceToLeader.x) <= (32 * player.player_id) && !player.onLedge):
					algorithmOverride += " + Close to partner"
					
					keyHold[INPUT.YDIR] = 0
					keyHold[INPUT.XDIR] = -sign(leader.direction)
					
					# Close to wall? No pro- ok so like, only if the leader is not nearby.
					if (player.closeToWall && (abs(distanceToLeader.x) > 32 || abs(roundi(distanceToLeader.y)) > 8)):
						algorithmOverride += " + Close to Wall"
						
						computer_jump()
				elif (player.onLedge):
					keyHold[INPUT.XDIR] = -sign(distanceToLeader.x)
					keyHold[INPUT.RUN] = true
			
			# If visibly possible, try getting to player's current platformer.
			if (player.triesGettingUp < 5):
				player.triesGettingUp += int(keyPress[INPUT.JUMP])
				# That, if player even is out of reach, it is being checked when there is something solid between their height.
				if (player.isPlayerDistantVertically != 0):
					algorithmOverride += " + Player Vertical"
					
					if (player.is_actually_on_floor()):
						if (player.onLedge):
							keyHold[INPUT.XDIR] = -sign(distanceToLeader.x)
						else:
							keyHold[INPUT.XDIR] = sign(distanceToLeader.x)
				# If not, it means the partner found a leak! He's still in the air so the partner'll have to jump.
				elif (player.willHaveToJump):
					algorithmOverride += " + Jump"
					
					if (roundi(distanceToLeader.y) == 0):
						player.willHaveToJump = false
						return
						
					computer_jump()
					if (player.is_actually_on_floor() && keyPress[INPUT.JUMP]):
						player.triesGettingUp += 1
			#If more than 164 pixels away on X, override AI control to come back.
			if abs(distanceToLeader.x) > 164:
				print("State changed to RETURN for Partner with ID: " + str(player.player_id))
				partnerState = FollowStage.RETURN
		FollowStage.RETURN:
			player.isPlayerDistantVertically = 0
			player.triesGettingUp = 5
			keyHold[INPUT.YDIR] = 0
			keyHold[INPUT.XDIR] = -sign(distanceToLeader.x)
			if (player.closeToWall):
				computer_jump()
			if (player.in_water && player.velocity.y >= 0 && !player.ledgeDetectionCast.is_colliding()):
				keyPress[INPUT.JUMP] = true
			
			if abs(distanceToLeader.x) > 96:
				keyHold[INPUT.RUN] = true
			
			if abs(distanceToLeader.x) <= 164:
				print("State changed to FOLLOW for Partner with ID: " + str(player.player_id))
				partnerState = FollowStage.FOLLOW

func handle_computer_movement(_delta: float) -> void:
	moves = leader.get_meta("PartnerMod").inputMemoryMovement[memoryPosition].duplicate()
	
	if (moves[MOVE.POWER] == "Small"):
		moves[MOVE.POWER] = "0"
	elif (moves[MOVE.POWER] == "Big"):
		moves[MOVE.POWER] = "1"
	elif (moves[MOVE.POWER] == "Fire"):
		moves[MOVE.POWER] = "2"
	elif (moves[MOVE.POWER] == "Superball"):
		moves[MOVE.POWER] = "3"
		
	if (!spawning):
		memoryPosition += 1
#endregion
