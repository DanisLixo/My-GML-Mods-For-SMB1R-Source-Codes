extends Object


#region Essencials (Makes my life easier)
var state: PlayerState
var player: Player
var moveset: MovesetPlus
#endregion

func set_essencials(chain: ModLoaderHookChain, setMoveset: bool = true) -> void:
	state = chain.reference_object
	player = state.player
	moveset = player.get_meta("movesetPlus") if (setMoveset) else moveset

#region Extensions
func enter(c: ModLoaderHookChain, msg := {}) -> void:
	set_essencials(c)
	
	c.execute_next([msg])

func exit(c: ModLoaderHookChain) -> void:
	set_essencials(c)
	
	c.execute_next()
	moveset.chargeJumpFrames = moveset.to_params("CHARGE_JUMP_TIME")

var s = 0
func handle_movement(c: ModLoaderHookChain, delta: float) -> void:
	set_essencials(c)
	
	if (moveset.dashBuffer > 0):
		moveset.dashBuffer -= delta
	
	if (player.is_actually_on_floor() or player.in_water or player.flight_meter > 0 or player.physics_params("CAN_AIR_TURN")) and player.input_direction != 0 and not player.crouching:
		player.direction = player.input_direction
	state.jump_buffer -= 1
	state.run_buffer -= 1
	if state.jump_buffer <= 0:
		state.jump_queued = false
	if Global.player_action_pressed("run", player.player_id):
		state.run_buffer = player.physics_params("RUN_STOP_BUFFER") / delta
	player.apply_gravity(delta)
	if player.is_actually_on_floor():
		var player_transform = player.global_transform
		player_transform.origin += Vector2.UP * 1
	if moveset.is_dashing:
		handle_dash(delta)
	elif player.is_actually_on_floor():
		state.handle_ground_movement(delta)
	elif player.in_water or player.flight_meter > 0:
		state.handle_swimming(delta)
	elif moveset.is_gliding:
		handle_glide(delta)
	else:
		state.handle_air_movement(delta)
	player.move_and_slide()
	player.moved.emit()

func grounded(c: ModLoaderHookChain, delta: float) -> void:
	set_essencials(c)
	
	player.jump_cancelled = false
	player.floor_constant_speed = sign(player.get_floor_normal().x) == -player.velocity_direction
	
	power_squat_jump()
	moveset.is_gliding = false
	moveset.has_glided = false
	moveset.glideTimer = moveset.to_params("GLIDE_TIMER")
	
	moveset.spin_jumping = false
	if player.velocity.y >= 0:
		player.has_jumped = false
		player.has_spring_jumped = false
		
		moveset.double_jumped = false
		moveset.spin_jumped = false
	
	if (moveset.to_params("CAN_DASH") && dash_just_pressed()):
		dash(delta)
	if Global.player_action_just_pressed("jump", player.player_id):
		player.handle_water_detection()
		if player.in_water or player.flight_meter > 0:
			state.swim_up()
			return
		elif (moveset.to_params("CAN_SPIN_JUMP") && !player.crouching && !moveset.spin_jumped && Global.player_action_pressed("move_up", player.player_id)):
			spin_jump()
		else:
			player.jump()
	if state.jump_queued and not (player.in_water or player.flight_meter > 0):
		if player.spring_bouncing == false:
			player.jump()
		state.jump_queued = false
	if not player.crouching:
		if Global.player_action_pressed("move_down", player.player_id):
			player.crouching = true
			AudioManager.play_sfx("crouch", player.global_position)
			AudioManager.kill_sfx("uncrouch")
	else:
		state.can_wall_push = player.test_move(player.global_transform, Vector2.UP * 8 * player.gravity_vector.y) and player.physics_params("CAN_BE_WALL_EJECTED")
		if Global.player_action_pressed("move_down", player.player_id) == false:
			if state.can_wall_push:
				state.wall_pushing = true
			else:
				state.wall_pushing = false
				player.crouching = false
				AudioManager.play_sfx("uncrouch", player.global_position)
				AudioManager.kill_sfx("crouch")
		else:
			player.crouching = true
			state.wall_pushing = false
		if state.wall_pushing:
			player.global_position.x += (-50 * player.direction * delta)
	if not player.looking_up:
		if Global.player_action_pressed("move_up", player.player_id) and not player.crouching:
			player.looking_up = true
			AudioManager.play_sfx("look_up", player.global_position)
			AudioManager.kill_sfx("stop_look_up")
	else:
		if not Global.player_action_pressed("move_up", player.player_id) and not player.crouching:
			player.looking_up = false
			AudioManager.play_sfx("stop_look_up", player.global_position)
			AudioManager.kill_sfx("look_up")

func in_air(c: ModLoaderHookChain) -> void:
	set_essencials(c)
	
	if (moveset.to_params("CAN_AIR_DASH")):
		if (dash_just_pressed()):
			dash(state.get_process_delta_time())
	if Global.player_action_just_pressed("jump", player.player_id):
		if (player.in_water && moveset.to_params("CAN_SWIM")) or player.flight_meter > 0:
			state.swim_up()
		elif (moveset.to_params("CAN_DOUBLE_JUMP") && !moveset.double_jumped):
			double_jump()
		elif (moveset.to_params("CAN_GLIDE") && !moveset.is_gliding):
			player.velocity.y = 0
			moveset.is_gliding = true
			if (moveset.glideTimer == 0):
				moveset.glideTimer = moveset.to_params("GLIDE_TIMER")
			if (moveset.to_params("SPEED_BUILD_UP")):
				if (player.input_direction != 0):
					player.direction = player.input_direction
				player.velocity.x = moveset.to_params("GLIDE_MAX_SPEED") * player.direction
		else:
			state.jump_queued = true
			state.jump_buffer = player.physics_params("JUMP_BUFFER")

func swim_up(c: ModLoaderHookChain) -> void:
	set_essencials(c)
	c.execute_next()
	
	if (moveset.jump_charged):
		moveset.jump_charged = false
		player.velocity.y *= moveset.to_params("CHARGE_JUMP_MODIFIER")

func handle_animations(c: ModLoaderHookChain) -> void:
	set_essencials(c)
	
	c.execute_next()
	var sprite_multiplier = player.sprite.get_meta("scale_multiplier", Vector2(1, 1))
	player.sprite.scale.x = (player.direction * sprite_multiplier.x) * player.gravity_vector.y

func get_animation_name(c: ModLoaderHookChain) -> String:
	set_essencials(c)
	
	var vel_x: float = abs(player.velocity.x)
	var vel_y : float = player.actual_velocity_y()
	var on_floor := player.is_actually_on_floor()
	var on_wall := player.is_actually_on_wall()
	var airborne := not on_floor
	var has_flight := player.has_wings
	var moving := vel_x >= 5 and not on_wall
	var pushing := player.input_direction != 0 and on_wall
	var running: float = vel_x >= player.physics_params("RUN_SPEED") - 10
	var run_jump: bool = abs(player.velocity_x_jump_stored) >= player.physics_params("RUN_SPEED") - 10

	var state_context := ""
	if player.in_water: state_context = "Water"
	elif has_flight: state_context = "Wing"

	var _state = func(anim_name: String) -> String:
		return state_context + anim_name

	var jump_context := ""
	if player.has_spring_jumped: jump_context = "Spring"
	elif player.has_star: jump_context = "Star"
	elif run_jump: jump_context = "Run"
	
	var jump = func(anim_name: String) -> String:
		return jump_context + anim_name
	
	if player.crouching and not state.wall_pushing:
		if (moveset.double_jumped):
			if player.bumping and player.can_bump_crouch_anim:
				return "CrouchDoubleBump"
			if airborne:
				return "CrouchDoubleFall" if vel_y >= 0 else "CrouchDoubleJump"
	
	if (!on_floor):
		if player.has_jumped:
			if (moveset.is_gliding):
				return "Glide"
			elif (moveset.has_glided):
				if (moveset.glideTimer > 0):
					return "GlideCancel"
				else:
					return "GlideFall"
			if (moveset.double_jumped):
				if (player.bumping && player.can_bump_jump_anim):
					return jump.call("DoubleJumpBump")
				if vel_y < 0:
					return jump.call("DoubleJump")
				else:
					return jump.call("DoubleJumpFall")
			if (moveset.spin_jumping):
				if (player.bumping && player.can_bump_jump_anim):
					return jump.call("SpinJumpBump")
				if vel_y < 0:
					return jump.call("SpinJump")
				else:
					return jump.call("SpinJumpFall")
	return c.execute_next()
#endregion

#region Local Methods that does not appear in the original and I thought I could just extend but no godot is weird
func power_squat_jump() -> void:
	if (!moveset.to_params("CAN_POWER_SQUAT_JUMP")):
		return
	if (player.crouching):
		if (moveset.chargeJumpFrames > 0):
			moveset.chargeJumpFrames -= 1
		else:
			moveset.jump_charged = true
	
	if (moveset.jump_charged):
		moveset.chargeJumpFrames = moveset.to_params("CHARGE_JUMP_TIME")
		if (player.input_direction != 0 && !player.crouching):
			moveset.jump_charged = false
	elif (!player.crouching && player.is_actually_on_floor()):
		moveset.jump_charged = false

func double_jump() -> void:
	player.has_jumped = false
	state.jump_queued = false
	player.jump_cancelled = false
	
	moveset.spin_jumping = false
	moveset.spin_jumped = true
	
	moveset.double_jumped = true
	player.jump()
	
func spin_jump() -> void:
	moveset.spin_jumping = true
	player.jump()

func dash_just_pressed() -> int:
	if (moveset.is_dashing):
		return 0
	
	var directionPressX = int(Global.player_action_just_pressed("move_right")) - int(Global.player_action_just_pressed("move_left"))
	var directionPressY = int(Global.player_action_just_pressed("move_down")) - int(Global.player_action_just_pressed("move_up"))
	if (moveset.to_params("DIRECTIONAL_DASH")):
		if (directionPressY != 0):
			moveset.dashPress += directionPressY
			if (directionPressY == sign(moveset.dashPress)):
				if (moveset.dashBuffer > 0):
					moveset.dashBuffer = 0
					moveset.dashDelay = moveset.to_params("DASH_DELAY")
					
					return 1
				else:
					moveset.dashBuffer = 0.5
			else:
				moveset.dashPress = 0
	if (directionPressX != 0):
		moveset.dashPress += directionPressX
		if (directionPressX == sign(moveset.dashPress)):
			if (moveset.dashBuffer > 0):
				moveset.dashBuffer = 0
				moveset.dashDelay = moveset.to_params("DASH_DELAY")
				
				return 1
			else:
				moveset.dashBuffer = 0.5
		else:
			moveset.dashPress = 0
	return 0

func dash(delta: float) -> void:
	moveset.is_dashing = true
	moveset.dashIncr = moveset.to_params("DASH_INCR")
	
	moveset.dashBuffer = 0
	
	if (moveset.dashDelay > 0):
		print("Hold it!")
		moveset.dash_start = true
		moveset.dashDelay -= delta
		
		await state.get_tree().process_frame
		dash(delta)
		
		return
	
	AudioManager.play_global_sfx("cannon")
	moveset.dash_start = false
	
	player.velocity.y = -moveset.to_params("DASH_HEIGHT")
	player.velocity.x = (moveset.to_params("DASH_SPEED") * sign(moveset.dashPress))

func handle_dash(delta: float) -> void:
	if (!moveset.is_dashing):
		return
		
	if (moveset.dashIncr > 0):
		print(str(moveset.dashIncr))
		moveset.dashIncr -= delta
		return
	
	print("I mean, yeah: %s" % str(player.velocity.x))
	var target_move_speed: float = player.physics_params("WALK_SPEED")
	if player.in_water or player.flight_meter > 0:
		target_move_speed = player.physics_params("SWIM_GROUND_SPEED")
	var walk_speed_requirement = abs(player.velocity.x) >= player.physics_params("WALK_SPEED") if not player.physics_params("CAN_RUN_ACCEL_EARLY") else true
	if ((Global.player_action_pressed("run", player.player_id) or state.run_buffer > 0) and walk_speed_requirement) and (not player.in_water and player.flight_meter <= 0) and player.can_run:
		target_move_speed = player.physics_params("RUN_SPEED")
	
	var target_decel = moveset.to_params("DASH_DECEL") if (player.is_actually_on_floor()) else moveset.to_params("AIR_DASH_DECEL")
	var clamp_values = target_move_speed if player.physics_params("CLAMP_GROUND_SPEED") else INF
	if (abs(player.velocity.x) > clamp_values):
		player.velocity.x = move_toward(player.velocity.x, clamp_values * player.input_direction, (target_decel / delta) * delta)
	else:
		print("Enough DASH!")
		moveset.is_dashing = false
		moveset.dashPress = 0
		
		if (Global.player_action_pressed("jump", player.player_id)):
			player.jump()
		
		player.velocity.y = 0
		player.velocity_x_jump_stored = player.velocity.x
		player.gravity = player.calculate_speed_param("JUMP_GRAVITY")
		
		player.apply_gravity(delta)

func handle_glide(delta: float) -> void:
	if (moveset.to_params("SMB2_FLOATING")):
		moveset.time_accumulated += delta * moveset.to_params("GLIDE_EFFECT_SPEED")
		moveset.smb2FXSin = sin(moveset.time_accumulated) * moveset.to_params("GLIDE_EFFECT_STRENGTH")
		
		player.position.y += moveset.smb2FXSin
	if (moveset.to_params("SPEED_BUILD_UP")):
		if (player.velocity_direction == 0 && moveset.playerVelocityDirection != 0):
			player.direction = -player.direction
		if (moveset.playerVelocityDirection == 0):
			moveset.playerVelocityDirection = player.direction
		if (player.velocity_direction != 0):
			moveset.playerVelocityDirection = player.velocity_direction
			
		if (player.input_direction != moveset.playerVelocityDirection && player.input_direction != 0):
			player.skidding = true
			player.velocity.x = (moveset.to_params("GLIDE_MAX_SPEED") * moveset.playerVelocityDirection) + (1 * moveset.playerVelocityDirection)
		elif player.input_direction != 0:
			player.skidding = false
		if (player.skidding):
			handle_glide_skid(delta)
		else:
			handle_glide_acceleration(delta)
	else:
		player.skidding = (player.input_direction != player.velocity_direction && player.input_direction != 0)
		if (player.skidding):
			handle_glide_skid(delta)
		elif (player.input_direction != 0):
			handle_glide_acceleration(delta)
		else:
			handle_glide_deceleration(delta)
	
	if (moveset.glideTimer > 0 && Global.player_action_pressed("jump", player.player_id)):
		moveset.glideTimer -= 1
		print(str(moveset.glideTimer))
	else:
		if (moveset.glideTimer > -1 || !Global.player_action_pressed("jump", player.player_id)):
			print("Stopped Gliding")
			moveset.is_gliding = false
			moveset.has_glided = true
			
			player.apply_gravity(delta)

func handle_glide_acceleration(delta: float) -> void:
	if (moveset.to_params("SPEED_BUILD_UP")):
		var targetAccel = moveset.to_params("GLIDE_ACCEL")
		if (abs(player.velocity.x) >= moveset.to_params("GLIDE_MAX_SPEED")):
			targetAccel *= 0.2
		player.velocity.x = move_toward(player.velocity.x, INF * player.direction, (targetAccel / delta) * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, moveset.to_params("GLIDE_MAX_SPEED") * player.input_direction, (moveset.to_params("GLIDE_ACCEL") / delta) * delta)

func handle_glide_deceleration(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, (moveset.to_params("GLIDE_DECEL") / delta) * delta)
	
func handle_glide_skid(delta: float) -> void:
	player.skid_frames += 1
	if (moveset.to_params("SPEED_BUILD_UP")):
		player.velocity.x = move_toward(player.velocity.x, moveset.to_params("GLIDE_MAX_SPEED") * -player.direction, (moveset.to_params("GLIDE_SKID") / delta) * delta)
		
		if abs(player.velocity.x) >= moveset.to_params("GLIDE_MAX_SPEED"):
			player.skidding = false
			player.skid_frames = 0
			player.direction = moveset.playerVelocityDirection
	else:
		player.velocity.x = move_toward(player.velocity.x, 1 * player.input_direction, (moveset.to_params("GLIDE_SKID") / delta) * delta)
		if player.velocity.x * -player.input_direction > moveset.to_params("GLIDE_MAX_SPEED") or player.input_direction == player.velocity_direction or player.input_direction == 0:
			player.skidding = false
			player.skid_frames = 0
#endregion
