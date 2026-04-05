class_name MovesetPlus extends Node

@onready var player: Player = get_parent()

# Although the idea of the mod is to be a moveset expansion,
# the player is just an anchor to everything that builds them.
# So the reason of a different node to hold variables 
# the original doesn't have is simply because I'm lazy.
# Metadata is a way to put it out but 
# I already made this system, hehe...
## Update: THEY CHANGED SO MUCH OH NO!!!!

# SENSITIVE.NOT: Nothing, normal experience.
# SENSITIVE.UNGRABBER: Collect power-ups, being totally ignored.
# SENSITIVE.INTOLERANT: Collect power-ups, touching them kills you.
# SENSITIVE.STOPPABLE: Touch enemies in any way.
# SENSITIVE.EXTREME: Touch enemies and collect power-ups. Basically kaizo, both leads to death.
enum SENSITIVE {
	NOT, UNGRABBER, INTOLERANT, STOPPABLE, EXTREME
}

## Determines the properties the mod adds to the player's moveset.
var MOVESET_PARAMETERS: Dictionary = {
	"Default": {
		# Visual
		"JUMPS_AFTER_FLAGPOLE_DOWN": false, # After descending the flagpole, the character will do a little jump and it will be, if they can, a star jump.
		# Gameplay
		"JUMP_DAMAGE": false,				# Jumping will kill an enemy from any point it interacts with you.

		"CAN_DOUBLE_JUMP": false,			# The character will be able to... double jump, hence the name.
		"DOUBLE_JUMP_MODIFIER": 0.85,		# How high the double jump gets, multiplies the normal jump strength.
		"DOUBLE_JUMP_DAMAGE": false,		# Ditto of jump_damage, but for when double jumping.
		
		"CAN_POWER_SQUAT_JUMP": false,		# SMB2 Power Squat Jump, hold crouch and super jump when flickering.
		"CHARGE_JUMP_TIME": 30.0, 			# How much it takes for the jump to charge.
		"CHARGE_JUMP_MODIFIER": 1.2,		# How high the jump gets when charged, multiplies the normal jump strength.

		"CAN_GLIDE": false,					# The character will be able to glide.
		"GLIDE_MAX_SPEED": 160.0,			# How fast it goes when gliding.
		"GLIDE_ACCEL": 6.0, # 3.0			# Acceleration of the glide.
		"GLIDE_DECEL": 1.25,				# Decelaration of the glide, is not used when speed build up is enabled.
		"GLIDE_SKID": 5.0, # 12.0
		"GLIDE_GRAVITY": 5.0,				# Gravity while gliding.
		"GLIDE_TIMER": 300.0, # -1.0		# How much time you can glide. If set to '-1', deactivates the timer.
		## This tries mimicking knuckles gliding style.
		"GLIDE_SPEED_BUILD_UP": false,		# Speed gets higher when glinding for longer.
		"GLIDE_BREAKS_BLOCKS": false,		# Gliding breaks blocks in front of you.
		"GLIDE_KILL_ENEMIES": false,		# Gliding kills enemies in front of you.
		## This brings the peach SMB2 floating style from Peach.
		"GLIDE_SMB2_FLOATING": true,
		"GLIDE_EFFECT_STRENGTH": 1.0,		# How strong you go up and down.
		"GLIDE_EFFECT_SPEED": 8.0,			# How fast you go up and down.

		"CAN_DASH": false,					# Dashing
		"CAN_AIR_DASH": false,				# Air Dashing (basically the same)

		"DIRECTIONAL_DASH": false, 			# Holding a direction and pressing the dash will cause him to go to that direction.
		"DAMAGE_DASH": false,				# You hurt enemies while dashing, instead of the opposite.
		"DASH_SPEED": 240.0,				# Speed set when first starting the dash.
		"DASH_DECEL": 8.0,					# Decelaration while dashing, don't affect your speed if dashing doesn't take long.
		"AIR_DASH_DECEL": 3.0,				# Ditto, but when in the air.
		"DASH_GRAVITY": 0.0,				# Gravity while dashing, can be used to create.
		"DASH_HEIGHT": 0.0,				# Dash y strength. Also happens in the air.
		"DASH_INCR": 8.0,					# How much the player's X velocity affects their dash height.
		"DASH_DELAY": -1.0,					# Sets a limit to a dash being holded. If set to '-1' or a low value, it will be literally/basically instant.

		"CAN_ATTACK": false,				# Attacking (THIS WILL USE THE ACTION BUTTON)
		"ATTACK_FULL_DAMAGE": false,		# Attacking will one-hit kill any enemy
		"DIRECTIONAL_ATTACK": false,		# Same as 'directional dash', but for attack
		"ATTACK_DAMAGE": 1.0,				# Attack strength, only for bowser (he's the only to have HP) if the number is higher than or equal to '1'

		## Ground Pound
		"CAN_GROUND_POUND": false,
		"GROUND_POUND_GRAVITY": 8.0,		# How fast you go down.

		## Super Jump after Ground Pound, when in the ground
		"CAN_JUMP_POUND": false,
		"POUND_JUMP_MODIFIER": 1.2,		# How high the jump gets, multiplies the normal jump strength.
		"POUND_JUMP_TIMER": 3.0,			# Time before going back to normal.

		## Wall Climb
		"CAN_WALL_CLIMB": false,
		"WALL_CLIMB_SPEED": 5.0,			# How fast you go up and down.

		## Wall Jump, if Wall Climb is enabled, this may bug when trying to jump off of the wall.
		"CAN_WALL_JUMP": false,
		"WALL_JUMP_MODIFIER": 1.0,		# How high the jump gets after jumping off the wall, multiplies the normal jump strength, is also used by Wall Climb.
		"WALL_HOLD_GRAVITY": 5.0,			# How fast you slide down the wall, is also used by Wall Climb.
		
		"CAN_SPIN_JUMP": false,
		"SPIN_JUMP_MODIFIER": 1.0,		# How high the jump gets after jumping off the wall, multiplies the normal jump strength, is also used by Wall Climb.
		
		## Shoulder Bash
		"CAN_SHOLDER_BASH": false,
		"SHOULDER_BASH_SPEED": 180.0,		# Shoulder Bash Speed.
		"SHOULDER_BASH_TIMER": 5.0,			# Time it takes.

		## Long Jump!!!!
		"CAN_LONG_JUMP": false,
		"CROUCH_TO_LONG_JUMP": false,
		"LONG_JUMP_MODIFIER": 0.2,
		"LONG_JUMP_SPEED": 180.0,

		## Bounce ability (like sonic's bubble)
		"CAN_BOUNCE": false,
		"BOUNCE_GRAVITY": 8.0,				# How fast you go down.
		"BOUNCE_JUMP_MODIFIER": 1.2,
		"BOUNCE_FULL_STOP": false,

		# Limitations
		"CAN_SWIM": true,					# Character can swim.
		"SENSITIVE_MODE": SENSITIVE.NOT,	# Enabling this makes the character worst.
		# LITERAL SONIC THE HEDGEHOG!!!
		"CAN_SPIN_DASH": false,
		"CAN_SUPER_PEELOUT": false,

		# Cheats (bleh :P)
		"FREE_MOVEMENT": false,
		"NO_COLLISION": false
	},
	"Small": {},
	"Big": {},
	"Fire": {},
	"Superball": {}
}

var MOVESET_COSMETIC_PARAMETERS: Dictionary = {
	"Default": { # Fallback parameters. Additional entries can be added through CharacterInfo.json.
		"SPIN_JUMP_SFX": "spin_jump"            # Determines which sound effect to play when spin jumping.
	},
	"Small": {},
	"Big": {}
} 

#region Technical only (Used only by the State Nodes)
var moveset_dict := MOVESET_PARAMETERS

var is_flag_jumping := false

var double_jumped := false

var chargeJumpFrames := 0
var jump_charged := false
var charged_jumping := false

var is_gliding := false
var has_glided := false

var isTurning := false

var spin_jumped := false
var spin_jumping := false

var glideTimer := 0
var smb2FXSin := 0.0
var time_accumulated := 0.0

var playerVelocityDirection := 0

var is_dashing := false
var dash_start := false
var dashBuffer := 0.0
var dashPress := 0
var dashDelay := 0
var dashIncr := 0
#endregion

func apply_character_physics_extended() -> void:
	var path = "res://Assets/Sprites/Players/" + player.character + "/CharacterInfo.json"
	var idCheck = int(Global.player_characters[player.player_id])
	
	if idCheck > 3:
		path = path.replace("res://Assets/Sprites/Players", Global.config_path.path_join("custom_characters/"))
	path = ResourceSetter.get_pure_resource_path(path)
	var json: Dictionary = JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text())
	
	if (json.get("sprite") != null):
		apply_mod_changes(json.sprite, "sprite")
	
	if (json.get("physics_plus") != null):
		moveset_dict = MOVESET_PARAMETERS
		apply_mod_changes(json.physics_plus)
	
	chargeJumpFrames = to_params("CHARGE_JUMP_TIME")

func apply_mod_changes(json: Dictionary, internal_obj: String = "") -> void:
	for key in json:
		var value = json[key]
		
		if get(key) is Dictionary and value is Dictionary:
			Global.merge_dict(get(key), value)
		else:
			if (value is Array):
				if (str(key).contains("-vector2")):
					value = convert_to_vector(key, json)
					key = key.replace("-vector2", "")
			if (internal_obj != ""):
				player.get(internal_obj).set(key, value)
				player.get(internal_obj).set_meta(key, value)
			else:
				set(key, value)
				player.set(key, value)
				player.set_meta(key, value)

func convert_to_vector(key: Variant, json: Dictionary) -> Vector2:
	return Vector2(float(json[key][0]), float(json[key][1]))

func to_params(type: String, params_dict: Dictionary = moveset_dict, key: String = "") -> Variant:
	var mult_applied = 1.0
	var is_movement = false
	# DawnLR: I got no clue what happens for it to not work,
	# For now, I still don't know what any of these means.
	# Edit: now I understand. I mean, totally justified method idk.
	
	for tag in ["WALK", "RUN", "AIR", "SWIM"]:
		if tag in type:
			is_movement = true
			break
	if "MULT" not in type and is_movement:
		if "ACCEL" in type or "SKID" in type:
			mult_applied = player.accel_mult
		elif "SPEED" in type:
			mult_applied = player.speed_mult
	
	if player.power_state != null:
		if key == "": key = player.power_state.state_name
		if key in params_dict:
			var state_dict = params_dict[key]
			if type in state_dict:
				var value = state_dict[type]
				if (value is int or value is float) and not (value is bool):
					return value * mult_applied
				return value
	if "Default" in params_dict:
		var default_dict = params_dict["Default"]
		if type in default_dict:
			var value = default_dict[type]
			if value is Dictionary:
				value = $ResourceSetterNew.get_variation_json(value).value
			if (value is int or value is float) and not (value is bool):
				return value * mult_applied
			return value
	
	print("NULL PARAMETER! Looking up: type='%s', key='%s'" % [type, key])
	return null
