extends Object

var ANIMATION_FALLBACKS_MODDED := {
	"FlagJump" : "StarJump",
	
	"PoweredSquatCrouch": "Crouch",
	"PoweredSquatJump": "Jump",
	"PoweredSquatFall": "JumpFall",
	
	"GlideStart": "Glide",
	"Glide": "Jump",
	"GlideAttack": "Glide",
	"GlideCancel": "GlideFall",
	"GlideFall": "JumpFall",
}

var player: Player
var moveset: MovesetPlus

func set_essencials(chain: ModLoaderHookChain, setMoveset: bool = false) -> void:
	player = chain.reference_object
	moveset = player.get_meta("movesetPlus") if (setMoveset) else moveset

func _ready(c: ModLoaderHookChain) -> void:
	player = c.reference_object
	
	var movesetNode = load("res://mods-unpacked/DawnLR-MovesetPlus/Scripts/Parts/Player/MovesetPlus.gd").new()
	movesetNode.name = "MovesetPlus"
	player.add_child(movesetNode)
	player.set_meta("movesetPlus", movesetNode)
	moveset = movesetNode
	
	var doubleJumpParticles: CPUParticles2D = load("res://mods-unpacked/DawnLR-MovesetPlus/Scenes/Prefabs/Particles/DoubleJumpParticles.tscn").instantiate()
	player.add_child(doubleJumpParticles)
	var newShader = load("res://mods-unpacked/DawnLR-MovesetPlus/Resources/Shaders/CrouchFlickeringSpriteThing.gdshader")
	player.sprite.material.shader = newShader
	
	ANIMATION_FALLBACKS_MODDED.merge(player.ANIMATION_FALLBACKS)
	
	c.execute_next()
	
	movesetNode.apply_character_physics_extended()
	Global.level_theme_changed.connect(movesetNode.apply_character_physics_extended)

func set_animation_fallbacks(c: ModLoaderHookChain) -> void:
	set_essencials(c)
	c.execute_next()
	
	var special_jump_contexts = {
		"Spring": "",
		"Run": "",
		"Jog": "",
		"Star": "",
		"StarSpring": "Star",
		"StarRun": "Star",
		"StarJog": "Star",
	}
	var special_jump_anims = [
		"SpinJump", "SpinJumpFall", "SpinJumpBump", 
		"DoubleJump", "DoubleJumpFall", "DoubleJumpBump"
	]
	
	player.add_anim_fallbacks(special_jump_contexts, special_jump_anims)

func jump(c: ModLoaderHookChain) -> void:
	set_essencials(c, true)
	
	var dJumpPartcls := player.get_node("DoubleJumpParticles")
	var jumpPitch := 1.0
	if (moveset.double_jumped):
		jumpPitch = 1.35
		dJumpPartcls.emitting = (Settings.file.visuals.extra_particles == 1)
	
	c.execute_next_async()
	moveset.jump_charged = false
	moveset.spin_jumped = true
	
	if (moveset.spin_jumping):
		AudioManager.kill_sfx(player.physics_params("JUMP_SFX", player.COSMETIC_PARAMETERS))
		AudioManager.play_sfx(moveset.to_params("SPIN_JUMP_SFX", moveset.MOVESET_COSMETIC_PARAMETERS), player.global_position)
	else:
		AudioManager.play_sfx(player.physics_params("JUMP_SFX", player.COSMETIC_PARAMETERS), player.global_position, jumpPitch)
	
func calculate_jump_height(c: ModLoaderHookChain, jump_height = player.physics_params("JUMP_SPEED_IDLE"), jump_incr = player.physics_params("JUMP_INCR")) -> float: # Thanks wye love you xxx (hes right thank you wye)
	set_essencials(c, true)
	
	var curJumpHeight = c.execute_next([jump_height, jump_incr])
	
	var JUMP_MODIFIER := 1.0
	if (moveset.double_jumped):
		JUMP_MODIFIER = moveset.to_params("DOUBLE_JUMP_MODIFIER")
	if (moveset.jump_charged):
		JUMP_MODIFIER = moveset.to_params("CHARGE_JUMP_MODIFIER")
	if (moveset.spin_jumping):
		JUMP_MODIFIER = moveset.to_params("SPIN_JUMP_MODIFIER")
	return curJumpHeight * JUMP_MODIFIER

func apply_gravity(c: ModLoaderHookChain, delta: float) -> void:
	set_essencials(c, true)
	
	var modified := false
	if !(player.in_water or player.flight_meter > 0):
		if (moveset.is_gliding || moveset.double_jumped || moveset.spin_jumping || moveset.is_dashing):
			modified = true
	
	if (modified):
		if (moveset.is_gliding):
			player.gravity = moveset.to_params("GLIDE_GRAVITY")
			if (player.velocity.y >= moveset.to_params("GLIDE_GRAVITY")):
				player.velocity.y = (player.gravity_vector.y * ((player.gravity / (1.5 if player.low_gravity else 1.0)) / delta)) * delta
				player.velocity.x += (player.gravity_vector.x * ((player.gravity / (1.5 if player.low_gravity else 1.0)) / delta)) * delta
			elif sign(player.gravity_vector.y) * player.velocity.y + player.physics_params("JUMP_HOLD_SPEED_THRESHOLD") > 0.0:
				player.gravity = player.calculate_speed_param("FALL_GRAVITY", player.velocity_x_jump_stored)
		if (moveset.is_dashing):
			player.gravity = moveset.to_params("DASH_GRAVITY")
		
		#region gravity vector + max fall speed
		player.velocity += (player.gravity_vector * ((player.gravity / (1.5 if player.low_gravity else 1.0)) / delta)) * delta
		var target_fall: float = player.physics_params("MAX_FALL_SPEED")
		if player.in_water:
			player.target_fall = player.physics_params("MAX_SWIM_FALL_SPEED")

		var gravityMult = (1.2 if player.low_gravity else 1.0)
		if player.gravity_vector.y > 0:
			player.velocity.y = clamp(player.velocity.y, -INF, (target_fall / gravityMult))
		else:
			player.velocity.y = clamp(player.velocity.y, -(target_fall / gravityMult), INF)
		#endregion
	else:
		c.execute_next([delta])

func get_fallback_animation(c: ModLoaderHookChain, animation_name := "") -> String:
	set_essencials(c, true)
	if !player.sprite.sprite_frames.has_animation(animation_name) && ANIMATION_FALLBACKS_MODDED.has(animation_name):
		return get_fallback_animation(c, ANIMATION_FALLBACKS_MODDED.get(animation_name))
	else:
		return c.execute_next([animation_name])

func handle_invincible_palette(c: ModLoaderHookChain) -> void:
	set_essencials(c, true)
	c.execute_next()
	
	player.sprite.material.set_shader_parameter("charged_jump", moveset.jump_charged)
