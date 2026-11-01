extends PlayerSprite

#region Parameters related, how much of it I will use? Idk yet
## Determines various important values of the player character.
@export_group("Player Parameters")
## Determines the physics properties of the player character, such as general movement values, hitboxes, and other typical behavior.
@export var PHYSICS_PARAMETERS: Dictionary = {
	"Default": { # Fallback parameters. Additional entries can be added through CharacterInfo.json.
		"COLLISION_SIZE": [8, 28],
		"CROUCH_COLLISION_SIZE": [8, 14],            # The player's hitbox scale when crouched.
		"CAN_AIR_TURN": false,             # Determines if the player can turn in mid-air.
		"CAN_BREAK_BRICKS": true,          # Determines if the player can break bricks in their current form.
		"CAN_BE_WALL_EJECTED": true,       # Determines if the player gets pushed out of blocks if inside of them.
		"ROUNDED_FLOOR_COLLISION": false,
		"JUMP_WALK_THRESHOLD": 60.0,       # The minimum velocity the player must move at to perform a walking jump.
		"JUMP_RUN_THRESHOLD": 135.0,       # The minimum velocity the player must move at to perform a running jump.
		
		"JUMP_GRAVITY_IDLE": 11.0,         # The player's gravity while jumping from an idle state, measured in px/frame.
		"JUMP_GRAVITY_WALK": 11.0,         # The player's gravity while jumping from a walking state, measured in px/frame.
		"JUMP_GRAVITY_RUN": 11.0,          # The player's gravity while jumping from a running state, measured in px/frame.
		"JUMP_SPEED_IDLE": 300.0,          # The strength of the player's idle jump, measured in px/sec.
		"JUMP_SPEED_WALK": 300.0,          # The strength of the player's walking jump, measured in px/sec.
		"JUMP_SPEED_RUN": 300.0,           # The strength of the player's running jump, measured in px/sec.
		"JUMP_INCR": 8.0,                  # How much the player's X velocity affects their jump speed.
		"JUMP_CANCEL_DIVIDE": 1.5,         # When the player cancels their jump, their Y velocity gets divided by this value.
		"JUMP_HOLD_SPEED_THRESHOLD": 0.0,  # When the player's Y velocity goes past this value while jumping, their gravity switches to FALL_GRAVITY.
		"JUMP_BUFFER": 10,
		"CLASSIC_BOUNCE_BEHAVIOR": false,  # Determines if the player can only get extra height from a bounce with upward velocity, as opposed to holding jump.
		"BOUNCE_SPEED": 200.0,             # The strength at which the player bounces off enemies without any extra input, measured in px/sec.
		"BOUNCE_JUMP_SPEED": 300.0,        # The strength at which the player bounces off enemies while holding jump, measured in px/sec.
		
		"FALL_GRAVITY_PREDETERMINED": false,         # Determines if the player's gravity is determined by their last X velocity from leaving the ground rather than their current X velocity.
		"FALL_GRAVITY_IDLE": 25.0,         # The player's gravity while falling from an idle state, measured in px/frame.
		"FALL_GRAVITY_WALK": 25.0,         # The player's gravity while falling from a walking state, measured in px/frame.
		"FALL_GRAVITY_RUN": 25.0,          # The player's gravity while falling from a running state, measured in px/frame.
		"MAX_FALL_SPEED": 280.0,           # The player's maximum fall speed, measured in px/sec.
		"CEILING_BUMP_SPEED": 45.0,        # The speed at which the player falls after hitting a ceiling, measured in px/sec.
		
		"CLAMP_GROUND_SPEED": false,       # Determines if the player's speed will get clamped while moving on the ground, emulating snappier movement.
		"MINIMUM_SPEED": 0.0,              # The player's minimum speed while actively moving.
		
		"WALK_SPEED": 96.0,                # The player's speed while walking, measured in px/sec.
		"GROUND_WALK_ACCEL": 4.0,          # The player's acceleration while walking, measured in px/frame.
		"WALK_SKID": 8.0,                  # The player's turning deceleration while running, measured in px/frame.
		"CAN_RUN_ACCEL_EARLY": false,      # Determines if the player can hold run before reaching walk speed to begin running.
		"RUN_STOP_BUFFER": 0.0,            # Determines the amount of time in seconds before running will stop once its initiated.
		"RUN_SPEED": 160.0,                # The player's speed while running, measured in px/sec.
		"GROUND_RUN_ACCEL": 1.25,          # The player's acceleration while running, measured in px/frame.
		"RUN_SKID": 8.0,     
		"ICE_ACCEL_MOD": 0.25,
		"ICE_DECEL_MOD": 0.25,
		"ICE_SKID_MOD": 0.25,              # The player's turning deceleration while running, measured in px/frame.
		
		"CLASSIC_SKID_CONDITIONS": false,  # Determines if the player's speed must be over SKID_THRESHOLD to begin skidding.
		"CAN_INSTANT_STOP_SKID": false,    # Determines if the player will instantly stop upon reaching the skid threshold.
		"SKID_THRESHOLD": 100.0,           # The horizontal speed required, to be able to start skidding.
		"SKID_STOP_THRESHOLD": 10.0,       # The maximum velocity required before the player will stop skidding.
		
		"GROUND_WALK_DECEL": 3.0,          # The player's grounded deceleration while no buttons are pressed, measured in px/frame.
		"GROUND_RUN_DECEL": 3.0,           # The player's grounded deceleration while no buttons are pressed from running speed, measured in px/frame.
		"DECEL_THRESHOLD": 0,
		"AIR_DECEL": 0.0,                  # The player's airborne deceleration while no buttons are pressed, measured in px/frame.
		
		"AIR_WALK_ACCEL": 3.0,             # The player's usual acceleration while in midair, measured in px/frame.
		"AIR_WALK_SKID_ACCEL": 4.5,        # The player's usual skid acceleration while in midair, measured in px/frame.
		"AIR_RUN_ACCEL": 3.0,              # The player's running acceleration while in midair, measured in px/frame.
		"AIR_RUN_SKID_ACCEL": 4.5,         # The player's running skid acceleration while in midair, measured in px/frame.
		"AIR_BACKWARDS_ACCEL": 3.0,        # The player's backwards acceleration while in midair, measured in px/frame.
		"AIR_BACKWARDS_SKID_ACCEL": 4.5,   # The player's backwards skid acceleration while in midair, measured in px/frame.
		"AIR_SKID_JUMP_SPEED_MINIMUM": 0.0,          # The minimum jump speed required to use 'skid' params instead of 'accel' params for air control.

		"LOCK_AIR_SPEED": false,           # Determines if the player can surpass their walk speed while in the air, aside from on trampolines.
		"USE_BACKWARDS_ACCEL": false,      # Determines if the player will use backwards acceleration while travelling backwards.
		"CAN_AIR_RUN_WITHOUT_RUN_BUTTON": false,     # Determines if the player must be holding the run button to allow for running speed in the air.
		"CAN_AIR_SKID_ALWAYS": true,       # Determines if the player uses 'skid' params instead of 'accel' params if jump started below a certain speed.
		"CAN_AIR_RUN_EARLY": false,        # Determines a multiplier to the player's acceleration when moving backwards in the air.
		
		"CLIMB_OFFSET": 5.0,               # The X position offset applied to the player when climbing.
		"CLIMB_UP_SPEED": 50.0,            # The player's speed while climbing upwards, measured in px/sec.
		"CLIMB_DOWN_SPEED": 120.0,         # The player's speed while climbing downwards, measured in px/sec.

		"TRAMPOLINE_SPEED": 500.0,         # The strength of a jump on a trampoline, measured in px/sec.
		"SUPER_TRAMPOLINE_SPEED": 1200.0,  # The strength of a jump on a super trampoline, measured in px/sec.
		
		"SWIM_SPEED": 95.0,                # The player's horizontal speed while swimming, measured in px/sec.
		"SWIM_GROUND_SPEED": 45.0,         # The player's horizontal speed while grounded underwater, measured in px/sec.
		"SWIM_DECEL": 3.0,                 # The player's deceleration in water while no buttons are pressed, measured in px/frame.
		"SWIM_HEIGHT": 100.0,              # The strength of the player's swim, measured in px/sec.
		"SWIM_EXIT_SPEED": 250.0,          # The strength of the player's jump out of water, measured in px/sec.
		"SWIM_GRAVITY": 2.5,               # The player's gravity while swimming, measured in px/frame.
		"MAX_SWIM_FALL_SPEED": 200.0,      # The player's maximum fall speed while swimming, measured in px/sec.
	},
	"Small": {
		"COLLISION_SIZE": [8, 14],
		"CROUCH_COLLISION_SIZE": [8, 12],
		"CAN_BREAK_BRICKS": false,
		"CAN_BE_WALL_EJECTED": false,
	},
	"Big": {},
	"Fire": {},
	"Superball": {}
}
## Determines the physics properties of the character while "Classic Physics" are enabled.
@export var CLASSIC_PARAMETERS: Dictionary = {
	"Default": { # This uses the same parameters as PHYSICS_PARAMETERS and should be updated whenever new parameters are added.
		"COLLISION_SIZE": [8, 28],        # The player's hitbox scale.
		"CROUCH_COLLISION_SIZE": [8, 14],             # The player's hitbox scale when crouched.
		"CAN_AIR_TURN": false,             # Determines if the player can turn in mid-air.
		"CAN_BREAK_BRICKS": true,          # Determines if the player can break bricks in their current form.
		"CAN_BE_WALL_EJECTED": true,       # Determines if the player gets pushed out of blocks if inside of them.
		"ROUNDED_FLOOR_COLLISION": true,
		"JUMP_WALK_THRESHOLD": 60.0,       # The minimum velocity the player must move at to perform a walking jump.
		"JUMP_RUN_THRESHOLD": 93.75,       # The minimum velocity the player must move at to perform a running jump.
		"JUMP_BUFFER": 2,
		"JUMP_GRAVITY_IDLE": 7.5,          # The player's gravity while jumping from an idle state, measured in px/frame.
		"JUMP_GRAVITY_WALK": 7.03,         # The player's gravity while jumping from a walking state, measured in px/frame.
		"JUMP_GRAVITY_RUN": 9.375,         # The player's gravity while jumping from a running state, measured in px/frame.
		"JUMP_SPEED_IDLE": 248.0,          # The strength of the player's idle jump, measured in px/sec.
		"JUMP_SPEED_WALK": 248.0,          # The strength of the player's walking jump, measured in px/sec.
		"JUMP_SPEED_RUN": 310.0,           # The strength of the player's running jump, measured in px/sec.
		"JUMP_INCR": 0.0,                  # How much the player's X velocity affects their jump speed.
		"JUMP_CANCEL_DIVIDE": 1.0,         # When the player cancels their jump, their Y velocity gets divided by this value.
		"JUMP_HOLD_SPEED_THRESHOLD": 0.0,  # When the player's Y velocity goes past this value while jumping, their gravity switches to FALL_GRAVITY.
		
		"CLASSIC_BOUNCE_BEHAVIOR": true,   # Determines if the player can only get extra height from a bounce with upward velocity, as opposed to holding jump.
		
		"BOUNCE_SPEED": {
			"SMB1": {"value": 248.0},
			"SMBLL": {"value": 370.0}
		},
		"BOUNCE_JUMP_SPEED": {
			"SMB1": {"value": 310.0},
			"SMBLL": {"value": 370.0}
		},                                 # The strength at which the player bounces off enemies without any extra input, measured in px/sec.   # The strength at which the player bounces off enemies while holding jump, measured in px/sec.
		
		"FALL_GRAVITY_PREDETERMINED": true,          # Determines if the player's gravity is determined by their last X velocity from leaving the ground rather than their current X velocity.
		"FALL_GRAVITY_IDLE": 26.25,        # The player's gravity while falling from an idle state, measured in px/frame.
		"FALL_GRAVITY_WALK": 22.5,         # The player's gravity while falling from a walking state, measured in px/frame.
		"FALL_GRAVITY_RUN": 33.75,         # The player's gravity while falling from a running state, measured in px/frame.
		"MAX_FALL_SPEED": 255.0,           # The player's maximum fall speed, measured in px/sec.
		"CEILING_BUMP_SPEED": 45.0,        # The speed at which the player falls after hitting a ceiling, measured in px/sec.
		
		"CLAMP_GROUND_SPEED": true,        # Determines if the player's speed will get clamped while moving on the ground, emulating snappier movement.
		"MINIMUM_SPEED": 4.46,             # The player's minimum speed while actively moving.
		
		"WALK_SPEED": 90.0,                # The player's speed while walking, measured in px/sec.
		"GROUND_WALK_ACCEL": 2.23,         # The player's acceleration while walking, measured in px/frame.
		"WALK_SKID": 6.1,                  # The player's turning deceleration while running, measured in px/frame.
		
		"CAN_RUN_ACCEL_EARLY": true,       # Determines if the player can hold run before reaching walk speed to begin running.
		"RUN_STOP_BUFFER": 0.167,          # Determines the amount of time in seconds before running will stop once its initiated.
		"RUN_SPEED": 150.0,                # The player's speed while running, measured in px/sec.
		"GROUND_RUN_ACCEL": 3.34,          # The player's acceleration while running, measured in px/frame.
		"RUN_SKID": 6.1,                   # The player's turning deceleration while running, measured in px/frame.
		
		"CLASSIC_SKID_CONDITIONS": true,   # Determines if the player's speed must be over SKID_THRESHOLD to begin skidding.
		"CAN_INSTANT_STOP_SKID": true,     # Determines if the player will instantly stop upon reaching the skid threshold.
		"SKID_THRESHOLD": 100.0,           # The horizontal speed required, to be able to start skidding.
		"SKID_STOP_THRESHOLD": 33.75,      # The maximum velocity required before the player will stop skidding.
		
		"GROUND_WALK_DECEL": 3.05,   
		"GROUND_RUN_DECEL": 3.05,
		"DECEL_THRESHOLD": 33.75,           # The player's grounded deceleration while no buttons are pressed, measured in px/frame.
		
		"AIR_DECEL": 0.0,                  # The player's airborne deceleration while no buttons are pressed, measured in px/frame.
		"AIR_WALK_ACCEL": 2.23,            # The player's usual acceleration while in midair, measured in px/frame.
		"AIR_WALK_SKID_ACCEL": 3.04,       # The player's usual skid acceleration while in midair, measured in px/frame.
		"AIR_RUN_ACCEL": 3.34,             # The player's running acceleration while in midair, measured in px/frame.
		"AIR_RUN_SKID_ACCEL": 3.34,        # The player's running skid acceleration while in midair, measured in px/frame.
		"AIR_BACKWARDS_ACCEL": 4.46,       # The player's backwards acceleration while in midair, measured in px/frame.
		"AIR_BACKWARDS_SKID_ACCEL": 4.46,  # The player's backwards skid acceleration while in midair, measured in px/frame.
		"AIR_SKID_JUMP_SPEED_MINIMUM": 105.0,        # The minimum jump speed required to use 'skid' params instead of 'accel' params for air control.

		"LOCK_AIR_SPEED": true,            # Determines if the player can surpass their walk speed while in the air, aside from on trampolines.
		"USE_BACKWARDS_ACCEL": true,       # Determines if the player will use backwards acceleration while travelling backwards.
		"CAN_AIR_RUN_WITHOUT_RUN_BUTTON": true,      # Determines if the player must be holding the run button to allow for running speed in the air.
		"CAN_AIR_SKID_ALWAYS": false,      # Determines if the player uses 'skid' params instead of 'accel' params if jump started below a certain speed.
		"CAN_AIR_RUN_EARLY": false,        # Determines a multiplier to the player's acceleration when moving backwards in the air.
		
		"CLIMB_OFFSET": 5.0,               # The X position offset applied to the player when climbing.
		"CLIMB_UP_SPEED": 50.0,            # The player's speed while climbing upwards, measured in px/sec.
		"CLIMB_DOWN_SPEED": 120.0,         # The player's speed while climbing downwards, measured in px/sec.

		"TRAMPOLINE_SPEED": 500.0,         # The strength of a jump on a trampoline, measured in px/sec.
		"SUPER_TRAMPOLINE_SPEED": 1200.0,  # The strength of a jump on a super trampoline, measured in px/sec.
		
		"SWIM_SPEED": 95.0,                # The player's horizontal speed while swimming, measured in px/sec.
		"SWIM_GROUND_SPEED": 45.0,         # The player's horizontal speed while grounded underwater, measured in px/sec.
		"SWIM_DECEL": 0.0,                 # The player's deceleration in water while no buttons are pressed, measured in px/frame.
		"SWIM_HEIGHT": 100.0,              # The strength of the player's swim, measured in px/sec.
		"SWIM_EXIT_SPEED": 250.0,          # The strength of the player's jump out of water, measured in px/sec.
		"SWIM_GRAVITY": 2.5,               # The player's gravity while swimming, measured in px/frame.
		"MAX_SWIM_FALL_SPEED": 200.0,      # The player's maximum fall speed while swimming, measured in px/sec.
	},
	"Small": {
		"COLLISION_SIZE": [8, 14],        # The player's hitbox scale.
		"CROUCH_COLLISION_SIZE": [8, 12],  
		"CROUCH_SCALE": 1.0,
		"CAN_BREAK_BRICKS": false,
		"CAN_BE_WALL_EJECTED": false,
	},
	"Big": {},
	"Fire": {},
	"Superball": {}
}
## Determines parameters typically involved with power-up behavior, mainly projectiles fired by the player.
@export var POWER_PARAMETERS: Dictionary = {
	"Default": {
		"STARTING_POWER_STATE": "Small",   # Determines the default starting power state.
		"STAR_TIME": 12.0,                 # Determines how long a Star will last for.
		"WING_TIME": 10.0,                 # Determines how long Wings will last for.
		"HAMMER_TIME": 10.0,               # Determines how long a Hammer will last for.
		
		"PROJ_TYPE": "",                   # Determines what projectile scene is used. Leaving this blank disables firing projectiles entirely.
		
		"PROJ_PARTICLE": "",               # Determines what particle scene is used. Leaving this blank disables particles from spawning.
		"PROJ_PARTICLE_OFFSET": [0, 0],    # Determines the spawn location of the projectile's particle.
		"PROJ_PARTICLE_ON_CONTACT": false, # Defines if the particle will play when making contact without being destroyed.
		
		"PROJ_EXTRA_PROJ": "",             # Determines if an extra projectile will be spawned. Leaving this blank will prevent any additional projectiles.
		"PROJ_EXTRA_PROJ_OFFSET": [0, 0],  # Determines the spawn location of the extra projectile spawned when destroyed.
		"PROJ_EXTRA_PROJ_ON_CONTACT": false,    # Defines if the extra projectile will spawn when the original makes contact without being destroyed.
		
		"PROJ_SFX_THROW": "fireball",      # Defines the sound effect that plays when this projectile is fired.
		"PROJ_SFX_COLLIDE": "bump",        # Defines the sound effect that plays when this projectile collides.
		"PROJ_SFX_HIT": "fireball_hit",    # Defines the sound effect that plays when this projectile hits an enemy.
		"PROJ_COLLECT_COINS": false,
		"MAX_PROJ_COUNT": 2,               # How many projectiles can be fired at once. -1 and below count as infinite.
		"PROJ_COLLISION": true,            # Determines if the projectile can interact with collidable surfaces.
		"PROJ_PIERCE_COUNT": 0,            # Determines how many additional enemies this projectile can hit before being destroyed. -1 and below count as infinite.
		"PROJ_PIERCE_HITRATE": -1,         # Determines how much time must pass in seconds before this projectile can hit the same enemy it is on top of currently. -1 and below count as infinite. 
		"PROJ_BOUNCE_COUNT": -1,           # Determines how many additional enemies this projectile can hit before being destroyed. -1 and below count as infinite.
		"PROJ_GROUND_BOUNCE": true,        # Determines if the projectile can bounce off the ground.
		"PROJ_WALL_BOUNCE": false,         # Determines if the projectile can bounce off of wals.
		"PROJ_CEIL_BOUNCE": false,         # Determines if the projectile can bounce off of ceilings.
		
		"PROJ_LIFETIME": -1.0,               # Determines how long the projectile will last for. -1 and below count as infinite.
		"PROJ_OFFSET": [-4.0, 16.0],       # Determines the offset for where the projectile will spawn.
		"PROJ_ANGLE" : null,               # Determines the exact angle the projectile is sent at in degrees. Leaving this blank disables angled behavior entirely.
		"PROJ_SPEED": [220.0, -100.0],     # Determines the initial velocity of the projectile.
		"PROJ_SPEED_UP": null,             # Changes the speed of the projectile if you hold UP.
		"PROJ_SPEED_DOWN": null,           # Changes the speed of the projectile if you hold DOWN.
		"PROJ_SPEED_UP_FORWARD": null,             # Changes the speed of the projectile if you hold UP amd LEFT/RIGHT.
		"PROJ_SPEED_DOWN_FORWARD": null,           # Changes the speed of the projectile if you hold DOWN and LEFT/RIGHT.
		"PROJ_SPEED_CAP": [-220.0, 220.0], # Determines the minimum and maximum X velocity of the projectile.
		"PROJ_SPEED_SCALING": false,       # Determines if the projectile will have its initial speed scale with the player's movement.
		
		"PROJ_GROUND_DECEL": 0.0,          # The projectile's deceleration on the ground, measured in px/frame
		"PROJ_AIR_DECEL": 0.0,             # The projectile's (horizontal) deceleration in the air, measured in px/frame
		"PROJ_AIR_DECEL_VERTICAL": 0.0,    # The projectile's (vertical) deceleration in the air, measured in px/frame. Useful for projectiles that have no gravity.
		"PROJ_GRAVITY": 15.0,              # The projectile's gravity, measured in px/frame
		"PROJ_BOUNCE_HEIGHT": 125.0,       # The projectile's bounce velocity upon landing on the ground.
		"PROJ_MAX_FALL_SPEED": 150.0,      # The projectile's maximum fall speed, measured in px/sec
		"PROJ_COOLDOWN": 0.0,
		"PROJ_HARMLESS": false,
		"PROJ_ELASTIC_BOUNCE_LIMIT": -1,
		"PROJ_ELASTIC_BOUNCE": [0, 0]
	},
	"Small": {
		"PROJ_OFFSET": [-4.0, 8.0],
	},
	"Big": {},
	"Fire": {
		"PROJ_TYPE": "res://Scenes/Prefabs/Entities/Items/Fireball",
		"PROJ_PARTICLE": "res://Scenes/Prefabs/Particles/FireballExplosion",
	},
	"Superball": {
		"PROJ_TYPE": "res://Scenes/Prefabs/Entities/Items/SuperballProjectile",
		"PROJ_PARTICLE": "res://Scenes/Prefabs/Particles/SmokeParticle",
		"PROJ_SFX_THROW": "superball",
		"PROJ_SFX_HIT": "superball_hit",
		"PROJ_GRAVITY": 0.0, 
		"PROJ_LIFETIME": 10.0,
		"PROJ_WALL_BOUNCE": true,
		"PROJ_CEIL_BOUNCE": true,
		"PROJ_FLOOR_BOUNCE": true,
		"PROJ_COLLECT_COINS": true,
		"PROJ_SPEED": [150.0, -150.0],
	}
}
## Determines values involving various ending sequences, such as grabbing the flagpole and walking to an NPC at the end of a level.
@export var ENDING_PARAMETERS: Dictionary = {
	"Default": {
		"FLAG_SKIP_GRAB": false,           # Determines if the player skips grabbing the flag entirely.
		"FLAG_HANG_TIMER": 1.5,            # How long the player will stick on the flagpole.
		"FLAG_SLIDE_SPEED": 125.0,         # How fast the player slides down the flagpole.
		
		"FLAG_INITIAL_X_VELOCITY": 0.0,    # Determines the player's initial X velocity after letting go of the flagpole.
		"FLAG_JUMP_SPEED": 0.0,            # How high the player will initially jump after letting go of the flagpole.
		"FLAG_JUMP_INCR": 8.0,             # How much the player's X velocity will influence the player's jump height.
		
		"FLAG_SPEED_MULT": 1.0,            # The multiplier applied onto the player's max speed when walking to the flag.
		"FLAG_ACCEL_MULT": 1.0,            # The multiplier applied onto the player's max acceleration when walking to the flag.
		"TOAD_SPEED_MULT": 1.0,            # The multiplier applied onto the player's max speed when walking to a Toad.
		"TOAD_ACCEL_MULT": 1.0,            # The multiplier applied onto the player's max acceleration when walking to a Toad.
		"PEACH_SPEED_MULT": 1.0,           # The multiplier applied onto the player's max speed when walking to Peach.
		"PEACH_ACCEL_MULT": 1.0,           # The multiplier applied onto the player's max acceleration when walking to Peach.
		
		"DOOR_POSE_OFFSET": 0.0,           # The offset of where the player performs their PoseDoor animation, if applicable.
		"TOAD_POSE_OFFSET": -12.0,         # The offset of where the player performs their PoseToad animation, if applicable.
		"PEACH_POSE_OFFSET": -12.0,        # The offset of where the player performs their PosePeach animation, if applicable.
	}
}
## Determines values involving death, unique separated by damage types rather than power states.
@export var DEATH_PARAMETERS: Dictionary = {
	"Default": {
		"DEATH_COLLISION": false,          # Determines whether the player will still collide with the level.
		"DEATH_HANG_TIMER": 0.5,           # The amount of time the player will freeze in the air for during the death animation in seconds
		"DEATH_X_VELOCITY": 0,             # The horizontal velocity the player gets sent at when dying, measured in px/sec
		"DEATH_DECEL": 3.0,                # The player's deceleration during death, measured in px/frame
		"DEATH_JUMP_SPEED": 300.0,         # The strength of the player's "jump" during the death animation, measured in px/sec
		"DEATH_FALL_GRAVITY": 11.0,        # The player's gravity while falling during death, measured in px/frame
		"DEATH_MAX_FALL_SPEED": 280.0,     # The player's maximum fall speed during death, measured in px/sec
	}
}
## Determines values involving purely cosmetic changes, including offsets for the wing and hammer sprites and configuration for various visual and audio effects.
@export var COSMETIC_PARAMETERS: Dictionary = {
	"Default": { # Fallback parameters. Additional entries can be added through CharacterInfo.json.
		"WING_OFFSET": [0.0, 0.0],         # The visual offset of the wings which appear with the Wing power-up.
		"HAMMER_OFFSET": [0.0, -8.0],      # The visual offset of the hammer which appears with the Hammer power-up.
		
		"MOVE_ANIM_SPEED_DIV": 32,         # Determines the value used for division in the animation speed formula for walk/run animations. Lower is faster.
		"CHECKPOINT_ICON_HEIGHT": -40,
		"RAINBOW_STAR_FX_SPEED": 15.0,     # Determines the speed of the rainbow effect under the effects of a star, measured in cycles/sec
		"RAINBOW_STAR_SLOW_FX_SPEED": 7.5, # Determines the speed of the rainbow effect nearing the end of a star's duration, measured in cycles/sec
		"RAINBOW_POWERUP_FX": true,        # Determines whether or not the player will play the rainbow effect when powering up.
		"RAINBOW_FX_SPEED": 15.0,          # Determines the speed of the rainbow effect in other scenarios, measured in cycles/sec
		"ICE_SPEED_MOD": 1.5,
		"WALK_SFX": "walk",                # Determines which sound effect to play when walking.
		"RUN_SFX": "run",                  # Determines which sound effect to play when running.
		"SKID_SFX": "skid",            # Determines which sound effect to play when skidding.
		"JUMP_SFX": "big_jump",            # Determines which sound effect to play when jumping.
		"TRAMPOLINE_SFX": "big_trampoline",          # Determines which sound effect to play when bouncing on a trampoline.
		"TRAMPOLINE_USED_SFX": "big_used_trampoline", # Determines which sound effect to play when actively using a trampoline.
		"GROUNDED_WALK_SFX": true,         # Forces walk sounds to only play when on the ground.
		"GROUNDED_RUN_SFX": true,          # Forces run sounds to only play when on the ground.
	},
	"Small": {
		"WING_OFFSET": [0.0, 10.0],
		"RAINBOW_POWERUP_FX": false,
		"JUMP_SFX": "small_jump",
		"TRAMPOLINE_SFX": "small_trampoline",
		"TRAMPOLINE_USED_SFX": "small_used_trampoline",
		"CHECKPOINT_ICON_HEIGHT": -24,
	},
	"Big": {
		"RAINBOW_POWERUP_FX": false,
	}
} 
@export_group("")

@export var physics_dict = PHYSICS_PARAMETERS
#endregion

const explosionParticlesScene := preload("res://mods-unpacked/DawnLR-Partner/Modded/Gameplay/Scenes/Prefabs/ExplosionParticles.tscn")

@onready var particles = $CosmicParticles
@onready var wallDetection := $WallDetection
@onready var ledgeDetectionCast := $LedgeDetectionCast
@onready var ledgeDetectionCast2 := $LedgeDetectionCast2
var thingie: Node

var direction := 1

var finalPos := (12 * player_id) * direction
var delayedPos := finalPos

var has_star := false
var has_wings := false
var has_hammer := false
var cooldown := false

var power_state = Global.player_power_states[player_id]
var projectile_amount := 0
var projectiles_fired_since_left_ground := 0
var projectile_type := load("res://Scenes/Prefabs/Entities/Items/Fireball.tscn")
var attacking := false

var behaviorSet := false

signal attacked

func _ready() -> void:
	super()
	set_partner_stuff()
	
	offset.y += 1
	
	colour_palette = ResourceSetter.get_resource(preload("uid://b0quveyqh25dn"))
	apply_character_physics()

func _process(delta: float) -> void:
	handle_direction()
	handle_move_speed()
	handle_behavior_stuff()
	handle_invincible_palette()
	handle_sounds()

func _physics_process(delta: float) -> void:
	z_index = thingie.leader.z_index - 1
	if (thingie.moves[thingie.MOVE.ANIM] != animation):
		play(thingie.moves[thingie.MOVE.ANIM])
	animation_changed.emit()
	
	handle_position(delta)
	handle_power_up(delta)

func handle_behavior_stuff() -> void:
	await get_tree().process_frame
	if (thingie.isEnemy):
		material.set_shader_parameter("mix_amount", 1)
		particles.show()
	else:
		material.set_shader_parameter("mix_amount", 0)
		particles.hide()
	
	behaviorSet = true

func handle_position(delta: float):
	var player = thingie.leader
	
	var dif := 12
	if (abs(player.velocity.x) != 0.0):
		dif = 2
	if (player.state_machine.get_state() != "Normal" || thingie.isEnemy):
		dif = 0
	var onGround = ledgeDetectionCast.is_colliding() && ledgeDetectionCast2.is_colliding()
	if !onGround:
		dif = player.direction
		
	finalPos = (dif * player_id) * -player.direction
	
	var onWall = wallDetection.is_colliding()
	
	
	if (delayedPos != finalPos && (onGround && !onWall)):
		delayedPos += (1 * -player.direction) + (((finalPos - delayedPos) / 60.0) * player_id)
	
	global_position = thingie.moves[thingie.MOVE.POS] + Vector2(delayedPos, 0)

func handle_direction():
	direction = thingie.moves[thingie.MOVE.DIR]
	if (delayedPos != finalPos):
		direction = sign(finalPos - delayedPos)
	scale.x = direction
	
func handle_sounds():
	var extra_particles = Settings.file.visuals.extra_particles == 1
	
	%SkidParticles.visible = extra_particles
	%SkidParticles.emitting = thingie.moves[thingie.MOVE.SKID]
	
	if (thingie.moves[thingie.MOVE.JUMPPRESS]):
		AudioManager.play_sfx(physics_params("JUMP_SFX", COSMETIC_PARAMETERS), global_position)
	
	var extra_sfx = Settings.file.audio.extra_sfx == 1
	if (thingie.moves[thingie.MOVE.SKID]):
		var skid_sfx = physics_params("SKID_SFX", COSMETIC_PARAMETERS)
		
		if (extra_sfx):
			AudioManager.play_sfx(skid_sfx, global_position, 1.0, false)
	else:
		var skid_sfx = physics_params("SKID_SFX", COSMETIC_PARAMETERS)
		if AudioManager.active_sfxs.has(skid_sfx) && extra_sfx:
			AudioManager.kill_sfx(skid_sfx)

func handle_move_speed():
	var player = thingie.leader
	
	speed_scale = 1.0
	for i in ["Walk", "Move", "Run", "Jog"]:
		if animation.ends_with(i):
			speed_scale = player.sprite.speed_scale
			break

func handle_power_up(delta: float):
	if (thingie.PARTNER_PERMANENT_SIZE == 1):
		thingie.moves[thingie.MOVE.POWER] = "0"
	if (thingie.PARTNER_PERMANENT_SIZE == 2 && thingie.moves[thingie.MOVE.POWER] == "0"):
		thingie.moves[thingie.MOVE.POWER] = "1"
	if (Global.player_power_states[player_id] != thingie.moves[thingie.MOVE.POWER]):
		Global.player_power_states[player_id] = thingie.moves[thingie.MOVE.POWER]
		power_state = Player.POWER_STATES[int(Global.player_power_states[player_id])]
		
		if (power_state != "Small"):
			$EnemyCollision/CollisionShape2D.shape.size = Vector2(12, 24)
			$EnemyCollision/CollisionShape2D.position.y = -12
		else:
			$EnemyCollision/CollisionShape2D.shape.size = Vector2(8, 12)
			$EnemyCollision/CollisionShape2D.position.y = -6
			
		update()
		offset.y += 1
	
	handle_projectile_firing(delta)
	
	handle_star(delta)
	handle_hammer(delta)
	handle_wing_flight(delta)

var star_meter := 0.0
func super_star() -> void:
	if physics_params("STAR_TIME", POWER_PARAMETERS) <= 0:
		return
	has_star = true
	material.set_shader_parameter("speed", physics_params("RAINBOW_STAR_FX_SPEED", COSMETIC_PARAMETERS))
	star_meter = clamp(physics_params("STAR_TIME", POWER_PARAMETERS) - 2, 0, INF)

var flight_meter := 0.0
func wing_get() -> void:
	if physics_params("WING_TIME", POWER_PARAMETERS) <= 0:
		return
	has_wings = true
	flight_meter = physics_params("WING_TIME", POWER_PARAMETERS)

var hammer_meter := 0.0
func hammer_get() -> void:
	if physics_params("HAMMER_TIME", POWER_PARAMETERS) <= 0:
		return
	has_hammer = true
	hammer_meter = physics_params("HAMMER_TIME", POWER_PARAMETERS)

var powerup_timers := ["star_meter", "flight_meter", "hammer_meter"]
func on_star_timeout() -> void:
	var time = clamp(physics_params("STAR_TIME", POWER_PARAMETERS), 0, 2) * 0.5
	material.set_shader_parameter("speed", physics_params("RAINBOW_STAR_SLOW_FX_SPEED", COSMETIC_PARAMETERS))
	await get_tree().create_timer(time, false).timeout
	AudioManager.stop_music_override(AudioManager.MUSIC_OVERRIDES.STAR)
	await get_tree().create_timer(time, false).timeout
	material.set_shader_parameter("speed", physics_params("RAINBOW_FX_SPEED", COSMETIC_PARAMETERS))
	if star_meter <= 0:
		has_star = false

func handle_star(delta:float) -> void:
	star_meter -= delta
	if star_meter <= 0 and has_star:
		on_star_timeout()
	
func handle_hammer(delta:float) -> void:
	hammer_meter -= delta
	if hammer_meter <= 0 and has_hammer:
		has_hammer = false
	%HammerSprite.visible = has_hammer
	%HammerHitbox.collision_layer = has_hammer
	if has_hammer:
		var hammer_offset = physics_params("HAMMER_OFFSET", COSMETIC_PARAMETERS)
		%HammerSprite.offset = Vector2(hammer_offset[0], hammer_offset[1])

func handle_wing_flight(delta: float) -> void:
	flight_meter -= delta
	if flight_meter <= 0 and has_wings:
		has_wings = false
	%Wings.visible = flight_meter > 0
	var wing_offset = physics_params("WING_OFFSET", COSMETIC_PARAMETERS)
	%Wing.offset = Vector2(wing_offset[0], wing_offset[1])
	if flight_meter <= 0:
		return
	if thingie.moves[thingie.MOVE.JUMPPRESS]:
		flap()
	if flight_meter <= 3:
		%Wings.get_node("AnimationPlayer").play("Flash")
	else:
		%Wings.get_node("AnimationPlayer").play("RESET")

func flap():
	%Wing.play("Flap")
	await get_tree().create_timer(0.3, false).timeout
	%Wing.play("Idle")

var colour_palette_texture: Texture = null
var colour_palette: Texture = null
const POWER_STATES := ["Small", "Big", "Fire", "Superball"]
func handle_invincible_palette() -> void:
	material.set_shader_parameter("mode", !Settings.file.visuals.rainbow_style)
	material.set_shader_parameter("player_palette", $PlayerPalette.texture)
	material.set_shader_parameter("palette_size", colour_palette.get_width())
	material.set_shader_parameter("palette_height", POWER_STATES.size())
	material.set_shader_parameter("invincible_palette", $InvinciblePalette.texture)
	material.set_shader_parameter("invincible_palette_size", $InvinciblePalette.texture.get_height())
	material.set_shader_parameter("palette_idx", int(thingie.moves[thingie.MOVE.POWER]))
	material.set_shader_parameter("enabled", (has_star))

func die_as_enemy():
	var partcles: PackParticles = explosionParticlesScene.instantiate()
	
	partcles.global_position = global_position
	partcles.player_id = player_id
	partcles.character = character
	add_sibling(partcles)
	partcles.emitting = true
	queue_free()

func get_power_up(_nothing, _nothiong) -> void:
	return

func apply_character_physics() -> void:
	var apply_gameplay_changes = true
	var path = "res://Assets/Sprites/Players/" + character + "/CharacterInfo.json"
	if int(Global.player_characters[player_id]) > 3:
		path = path.replace("res://Assets/Sprites/Players", Global.config_path.path_join("custom_characters/"))
	path = ResourceSetter.get_pure_resource_path(path)
	var json = JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text())
	
	for key in json.physics:
		if key in ["PHYSICS_PARAMETERS", "CLASSIC_PARAMETERS", "POWER_PARAMETERS", "ENDING_PARAMETERS"]:
			if apply_gameplay_changes:
				if get(key) is Dictionary and json.physics[key] is Dictionary:
					Global.merge_dict(get(key), json.physics[key])
				else:
					set(key, json.physics[key])
		else:
			if get(key) is Dictionary and json.physics[key] is Dictionary:
				Global.merge_dict(get(key), json.physics[key])
			else:
				set(key, json.physics[key])

func set_partner_stuff() -> void:
	add_to_group("Players-AI")
	
	var thingieNode = load("res://mods-unpacked/DawnLR-Partner/Modded/Gameplay/Scripts/Classes/PartnerThingie.gd").new()
	thingieNode.name = "PartnerThingie"
	add_child(thingieNode)
	
	thingie = thingieNode
	set_meta("thingie", thingieNode)
	set_meta("PowerStateDifference", 0)
	
	thingie.set_config()

func physics_params(type: String, params_dict: Dictionary = {}, key: String = "") -> Variant:
	var mult_applied = 1.0
	var is_movement = false
	# SkyanUltra: This is a stupid workaround for a stupid issue with this stupid
	# engine. I can't just set params_dict to physics_dict... So I have to do this
	# work around. I hate it. If anyone can fix it, then please. Do it.
	if params_dict == {}: params_dict = physics_dict
	for tag in ["WALK", "RUN", "AIR", "SWIM"]:
		if tag in type:
			is_movement = true
			break
	if power_state != null:
		if key == "": key = power_state
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

func handle_projectile_firing(delta: float) -> void:
	if (thingie.isEnemy):
		return
	var player = thingie.leader
	
	if (player.state_machine.state.name == "Normal") and not (physics_params("PROJ_TYPE", POWER_PARAMETERS) == ""):
		if thingie.moves[thingie.MOVE.ACTPRESS] and can_fire_projectile() and delta > 0:
			if physics_params("PROJ_TYPE", POWER_PARAMETERS) != "":
				throw_projectile()
			if physics_params("PROJ_COOLDOWN", POWER_PARAMETERS) and (physics_params("PROJ_COOLDOWN", POWER_PARAMETERS) > 0):
				cooldown = true
				await get_tree().create_timer(physics_params("PROJ_COOLDOWN", POWER_PARAMETERS)).timeout
				cooldown = false
				if physics_params("PROJ_SFX_COOLDOWN_END", POWER_PARAMETERS):
					AudioManager.play_sfx(physics_params("PROJ_SFX_COOLDOWN_END", POWER_PARAMETERS), global_position)

func can_fire_projectile():
	return (not cooldown) and ((projectile_amount < physics_params("MAX_PROJ_COUNT", POWER_PARAMETERS) or physics_params("MAX_PROJ_COUNT", POWER_PARAMETERS) < 0))

func throw_projectile() -> void:
	attacked.emit()
	projectile_type = load(physics_params("PROJ_TYPE", POWER_PARAMETERS) + ".tscn")
	var node = projectile_type.instantiate()
	var offset = physics_params("PROJ_OFFSET", POWER_PARAMETERS)
	var angle = Vector2.ZERO if physics_params("PROJ_ANGLE", POWER_PARAMETERS) == null else Vector2.from_angle(deg_to_rad(physics_params("PROJ_ANGLE", POWER_PARAMETERS)))
	var speed = physics_params("PROJ_SPEED", POWER_PARAMETERS)
	
	speed = calculate_angle_param("PROJ_SPEED")
	
	var speed_scaling = 0
	if physics_params("PROJ_SPEED_SCALING", POWER_PARAMETERS):
		speed_scaling = thingie.leader.velocity.x * direction
	
	node.global_position = global_position - Vector2(offset[0] * direction, offset[1])
	if "direction" in node: node.direction = direction
	if "velocity" in node: node.velocity = Vector2((speed[0] + speed_scaling) * direction, -speed[1])
	if node is Projectile:
		node.is_friendly = true
		if "character" in node:
			node.character = character
		node.PARTICLE = load(physics_params("PROJ_PARTICLE", POWER_PARAMETERS) + ".tscn")
		for param in thingie.leader.POWER_PARAM_LIST:
			node.set(param, physics_params(thingie.leader.POWER_PARAM_LIST[param], POWER_PARAMETERS))
		node.MOVE_SPEED = speed[0] + speed_scaling
		node.MOVE_ANGLE = angle
	call_deferred("add_sibling", node)
	if not (thingie.leader.is_on_floor() or thingie.leader.in_water):
		projectiles_fired_since_left_ground += 1
	projectile_amount += 1
	node.tree_exited.connect(func(): projectile_amount -= 1)
	
	AudioManager.play_sfx(physics_params("PROJ_SFX_THROW", POWER_PARAMETERS), global_position)
	attacking = true
	await get_tree().create_timer(0.1, false).timeout
	attacking = false

func calculate_angle_param(prefix):
	var vert_input = sign(Input.get_axis("move_up" + "_" + str(player_id),"move_down" + "_" + str(player_id)))
	var horiz_input = sign(Input.get_axis("move_right" + "_" + str(player_id),"move_left" + "_" + str(player_id)))
	var word_out = prefix
	if physics_params(word_out + "_UP", POWER_PARAMETERS) && (vert_input < 0):
		word_out = word_out + "_UP"
	elif physics_params(word_out + "_DOWN", POWER_PARAMETERS) && (vert_input > 0):
		word_out = word_out + "_DOWN"
	if physics_params(word_out + "_FORWARD", POWER_PARAMETERS) && (horiz_input != 0):
		word_out = word_out + "_FORWARD"
	if physics_params(word_out + "_AIR", POWER_PARAMETERS) && !thingie.leader.is_on_floor():
		word_out = word_out + "_AIR"
		
	return physics_params(word_out, POWER_PARAMETERS)


func on_player_detection(area: Area2D) -> void:
	if (area.owner is not Player):
		return
		
	if (thingie.isEnemy && thingie.damagesPlayer):
		area.owner.damage()
