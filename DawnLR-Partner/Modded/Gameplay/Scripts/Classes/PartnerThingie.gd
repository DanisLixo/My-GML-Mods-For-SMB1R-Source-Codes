extends Node

#region they did NOT expected any mod of this sort and it shows
const PHYSICS_PARAMETERS: Dictionary = {
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
const CLASSIC_PARAMETERS: Dictionary = {
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
			"SMBLL": {"value": 370.0},
			"SMBANN": {"link": "SMBLL"}
		},
		"BOUNCE_JUMP_SPEED": {
			"SMB1": {"value": 310.0},
			"SMBLL": {"value": 370.0},
			"SMBANN": {"link": "SMBLL"}
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
const POWER_PARAMETERS: Dictionary = {
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
const ENDING_PARAMETERS: Dictionary = {
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
const DEATH_PARAMETERS: Dictionary = {
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
const COSMETIC_PARAMETERS: Dictionary = {
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
		"WALK_SFX": "",                # Determines which sound effect to play when walking.
		"RUN_SFX": "",                  # Determines which sound effect to play when running.
		"SKID_SFX": "skid",            # Determines which sound effect to play when skidding.
		"JUMP_SFX": "big_jump",            # Determines which sound effect to play when jumping.
		"TRAMPOLINE_SFX": "big_trampoline",          # Determines which sound effect to play when bouncing on a trampoline.
		"TRAMPOLINE_USED_SFX": "big_used_trampoline", # Determines which sound effect to play when actively using a trampoline.
		"GROUNDED_WALK_SFX": true,         # Forces walk sounds to only play when on the ground.
		"GROUNDED_RUN_SFX": true,          # Forces run sounds to only play when on the ground.
		"PIPE_CUTSCENE_MOVE_SPEED": 48.0
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
#endregion

# Options
const partnerScene := preload("res://mods-unpacked/DawnLR-Partner/Modded/Gameplay/Scenes/Prefabs/Entities/Partner.tscn")
const partnerSimpleScene := preload("res://mods-unpacked/DawnLR-Partner/Modded/Gameplay/Scenes/Prefabs/Entities/PartnerSprite.tscn")
const bubbleScene := preload("res://mods-unpacked/DawnLR-Partner/Modded/Gameplay/Scenes/Bubble.tscn")
const glowScene := preload("res://mods-unpacked/DawnLR-Partner/Modded/Gameplay/Scenes/CosmicGlow.tscn")

# Global (Both use)
var partners: Array = []
# Partner Inputing help
enum INPUT {XDIR, YDIR, JUMP, RUN, ACTION}
var keyPress := [0,0,0,0,0]
var keyHold := [0,0,0,0,0]
var keyRelease := [0,0,0,0,0]
# Copy movement stuff
enum MOVE {POS, DIR, ANIM, POWER, JUMPPRESS, ACTPRESS, SKID}
var moves := [Vector2(-99999999, -99999999), 1, "Spawning", "0", false, false, false]
var intendedAnim := ""
var playerOverride := ""

var damagesPlayer := false
var spawned := false

var isEnemy := false
var stunned := false

#region Partner shit (a lot is from Sonic Worlds Next and my gmSMB mod)
@onready var player = get_parent()
# Partner setup.
var leader: Player
# Respawn if they're lost.
var respawnTime := 0.0
# Input memory from player to the partner to replicate, it will only work if they're being able to follow you.
var INPUT_MEMORY_LENGTH := 0
var inputMemoryPress = []
var inputMemoryHold = []
var inputMemoryRelease = []
# Movement memory from player to the partner to replicate.
var inputMemoryMovement = []
# Memory track so they grab what the leader did and reproduce.
const frameLimit := [60, 60, 120, 144, 240]

var memoryPosition := 0

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

@onready var PartnerSettings = Settings.get_meta("PartnersMod") 

var PARTNER_STYLE := FollowStyle.CPU
var PARTNER_BEHAVIOR := FollowBehavior.NORMAL
var PARTNER_PERMANENT_SIZE = 0
var PARTNER_MUTED := 0
var PARTNER_POWER_EXCLUSIVE := 0
var PARTNER_PHYSICS := 0
var PARTNER_RESPAWN_TIME := 5.0

var partnerState := FollowStage.FOLLOW
#endregion

var copy_from_id := 0
var saved_state := [0, "Small", FollowBehavior.NORMAL]

func _init() -> void:
	Global.set_meta("player_characters_backup", Global.player_characters.duplicate())

func _exit_tree() -> void: 
	Global.set_meta("last_played_id", copy_from_id)
	
	Global.player_characters = Global.get_meta("player_characters_backup", [0, 1, 2, 3]).duplicate()
	Settings.save_settings()

func _ready() -> void:
	await player.ready
	
	INPUT_MEMORY_LENGTH = 120 * Global.player_characters.size() 
	if (PartnerSettings.file.selector.follow_mode == FollowStyle.COPY && PartnerSettings.file.selector.behavior.has(FollowBehavior.ENEMY)):
		INPUT_MEMORY_LENGTH = (320 * PartnerSettings.file.selector.behavior.count(FollowBehavior.ENEMY)) * 1 + int(PartnerSettings.file.selector.enemy_spawn_delay)
	
	save_character_state()
	
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
		if (leader.get_meta("thingie").inputMemoryPress.size() != 0 || leader.get_meta("thingie").inputMemoryMovement.size() != 0):
			partner_process(delta)

func _physics_process(delta: float) -> void:
	if (is_leader()):
		leader_physics_process(delta)

func is_leader() -> bool:
	return player == get_tree().get_first_node_in_group("Players")

func set_config() -> void:
	var options: Dictionary = PartnerSettings.file.cpu_options
	if (PartnerSettings.file.selector.follow_mode == FollowStyle.COPY):
		options = PartnerSettings.file.copy_options
		PARTNER_STYLE = FollowStyle.COPY
	
	PARTNER_BEHAVIOR = int(PartnerSettings.file.selector.behavior[player.player_id]) as FollowBehavior
	
	PARTNER_PERMANENT_SIZE = options.permanent_size
	PARTNER_MUTED = options.muted
	
	if (PARTNER_STYLE == FollowStyle.CPU):
		PARTNER_POWER_EXCLUSIVE = options.power_up_exclusivity
		PARTNER_PHYSICS = options.apply_physics
		PARTNER_RESPAWN_TIME = options.respawn_time
	
	match (PARTNER_BEHAVIOR):
		FollowBehavior.ENEMY:
			if (PARTNER_STYLE == FollowStyle.CPU):
				PARTNER_PERMANENT_SIZE = 2 # That means big.
				PARTNER_POWER_EXCLUSIVE = 1 # Yes only himself get the prize.
				player.handle_power_up_sync()
			
			isEnemy = true
			
		FollowBehavior.FREE:
			PARTNER_POWER_EXCLUSIVE = 1 # Yes only himself get the prize.
	
	respawnTime = PARTNER_RESPAWN_TIME

func find_my_partners():
	if (!is_leader()):
		await get_tree().process_frame
	
	if (!isEnemy && !is_leader()):
		partners.push_front(leader)
		
	var arr = get_tree().get_nodes_in_group("Players-AI")
	for i in arr.size():
		var partner = arr[i - 1]
		if (partner != player):
			if (PartnerSettings.file.selector.behavior[i + 1] == FollowBehavior.FREE):
				continue
			
			if (isEnemy && PartnerSettings.file.selector.behavior[i + 1] == FollowBehavior.ENEMY):
				partners.push_front(partner)
			elif (!isEnemy && PartnerSettings.file.selector.behavior[i + 1] != FollowBehavior.ENEMY):
				partners.push_front(partner)
				
	if (Global.get_meta("last_played_id", -1) > -1 && is_leader()):
		copy_from_id = Global.get_meta("last_played_id")
		
		l_change_character(0, copy_from_id)

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

func save_character_state(save_id := true) -> void:
	if (save_id):
		saved_state[0] = Global.get_meta("player_characters_backup")[player.player_id]
	saved_state[1] = player.power_state.name
	saved_state[2] = int(PartnerSettings.file.selector.behavior[player.player_id]) as FollowBehavior

func force_player_soft_restart() -> void:
	var arr: Array = get_all_children(player)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.process_mode = Node.PROCESS_MODE_DISABLED
	
	for n in arr:
		if (n == player):
			reset_character_physics()
			player.apply_character_physics()
		elif (n.has_method("_ready")):
			n._ready()
	
	if (player.sprite == null):
		printerr("The game is about to explode!!!!! ABORT!")
		get_tree().change_scene_to_file("res://Scenes/Levels/Disclaimer.tscn")
	
	process_mode = Node.PROCESS_MODE_INHERIT
	player.process_mode = Node.PROCESS_MODE_INHERIT

func reset_character_physics() -> void:
	for parameters in ["PHYSICS_PARAMETERS", "CLASSIC_PARAMETERS", "POWER_PARAMETERS", "ENDING_PARAMETERS", "DEATH_PARAMETERS", "COSMETIC_PARAMETERS"]:
		player.set(parameters, get(parameters).duplicate_deep())

func get_all_children(in_node, arr := []):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child, arr)
	return arr

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
	l_add_partners()

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
	
	if (player.is_actually_on_floor() || player.in_water):
		player.set_meta("last_safe_spot", player.global_position)
	
	memoryPosition += 1

func leader_physics_process(_delta: float):
	if (PartnerSettings.file.selector.follow_mode == FollowStyle.CPU):
		l_handle_input()
	else: 
		l_handle_movement()
	
	if (Global.player_action_just_pressed("swap_characters", player.player_id) && ["Normal", "Climb"].has(player.state_machine.get_state())):
		var old_id := copy_from_id
	
		copy_from_id += 1
		copy_from_id = wrapi(copy_from_id, 0, ([player] + partners).size())
		
		l_change_character(old_id, copy_from_id)

func l_change_character(from_id := 0,  to_id := 1) -> void:
	var old_character = ([player] + partners)[from_id]
	var character_to_switch = ([player] + partners)[to_id]
	
	if (to_id != 0):
		character_to_switch.get_meta("thingie").save_character_state()
	
	old_character.get_meta("thingie").copy_character_from_player(old_character)
	
	copy_character_from_player(character_to_switch)
	character_to_switch.get_meta("thingie").copy_character_from_player(leader)

func copy_character_from_player(pl: Player) -> void:
	Global.player_characters[player.player_id] = pl.get_meta("thingie").saved_state[0]
	player.power_state = pl.get_node("PowerStates/" + pl.get_meta("thingie").saved_state[1])
	player.get_meta("thingie").PARTNER_BEHAVIOR = pl.get_meta("thingie").saved_state[2]
	
	pl.do_smoke_effect()
	
	force_player_soft_restart()

func l_add_partners() -> void:
	for i in Global.player_characters.size():
		if i != 0 && Global.player_characters[i] != -1:
			var curPartner = l_set_partner_by_id(i)
			if (!curPartner.is_node_ready()):
				await curPartner.ready
			if (PipeArea.exiting_pipe_id != -1 
			&& PARTNER_STYLE == FollowStyle.CPU
			&& !enemiesArray.has(curPartner)):
				curPartner.state_machine.transition_to("Freeze")
				curPartner.global_position = Vector2(-999999, -999999)
			curPartner.thingie.leader = player
	find_my_partners()
	
	if (PartnerSettings.file.selector.behavior.has(FollowBehavior.ENEMY)):
		l_create_spawner()
	else:
		for i in get_tree().get_nodes_in_group("Players-AI"):
			i.thingie.spawned = true

var enemiesArray := []
func l_set_partner_by_id(i: int) -> Node2D:
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
	
	if (PartnerSettings.file.selector.behavior[i] == FollowBehavior.ENEMY):
		enemiesArray.append(curPartner)
	
	return curPartner

var spawner: Node2D
func l_create_spawner() -> void:
	if (PartnerSettings.file.selector.follow_mode == FollowStyle.CPU):
		spawner = bubbleScene.instantiate()
		spawner.global_position = Vector2(player.global_position.x, -64)
	else:
		spawner = glowScene.instantiate()
		spawner.global_position = Vector2(player.global_position.x, player.global_position.y - 16)
	
	spawner.thingie = self
	spawner.spawnTime = PartnerSettings.file.selector.enemy_spawn_delay
	
	var arr = get_tree().get_nodes_in_group("Players-AI")
	for i in arr.size():
		var partner = arr[i - 1]
		if (enemiesArray.has(partner)):
			partner.global_position = player.global_position
		else:
			partner.thingie.spawned = true
	
	spawner.enemies = enemiesArray.duplicate()
	
	get_tree().current_scene.add_child.call_deferred(spawner)

## Used only by the leader, it needs to be set so partners can use it.
func l_handle_input() -> void:
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
	
func l_handle_movement() -> void:
	moves[MOVE.POS] = player.global_position
	moves[MOVE.DIR] = player.direction
	moves[MOVE.ANIM] = l_get_intended_animation()
	moves[MOVE.POWER] = player.power_state.name
	moves[MOVE.JUMPPRESS] = Global.player_action_just_pressed("jump", 0)
	moves[MOVE.ACTPRESS] = Global.player_action_just_pressed("action", 0)
	moves[MOVE.SKID] = player.skidding
	
var old_power_state := ""
var new_power_state := ""
func l_get_intended_animation() -> String:
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
	if (PARTNER_BEHAVIOR != FollowBehavior.FREE):
		find_my_partners()
	
	if (PARTNER_BEHAVIOR == FollowBehavior.FREE
	|| isEnemy):
		var possible_flagpoles = get_tree().get_nodes_in_group("Flagpole") + get_tree().get_nodes_in_group("CastleBridges")
		
		var idx := 0
		while flagpole is not Node2D:
			flagpole = possible_flagpoles[idx]
			
			idx += 1
		if (flagpole.get_node_or_null("Axe")):
			flagpole = flagpole.get_node_or_null("Axe")
		
		if (flagpole == null):
			for pipe in get_tree().current_scene.get_children():
				if (pipe is PipeArea):
					if (!pipe.exit_only && pipe.pipe_id == 0):
						flagpole = pipe
						break
		if (PARTNER_BEHAVIOR == FollowBehavior.ENEMY):
			player.global_position -= Vector2(16, 16)
	
	memoryPosition = 0 - (8 * (frameLimit[Settings.file.video.frame_limit]/60.0)) * (player.player_id * 0.8) # INPUT_MEMORY_LENGTH - (INPUT_MEMORY_LENGTH / float(guys)) * player.player_id * 0.8
	
	print("Eu to fiocando doido P%s: %s" % [player.player_id, memoryPosition])
	
	if (PARTNER_BEHAVIOR == FollowBehavior.ENEMY):
		memoryPosition = 0 - (frameLimit[Settings.file.video.frame_limit]) * (player.player_id * 0.8)

func partner_process(delta: float) -> void:
	if (memoryPosition >= 0):
		memoryPosition = memoryPosition % INPUT_MEMORY_LENGTH
	
	if (PARTNER_STYLE == FollowStyle.CPU):
		p_handle_computer_input(delta)
	else:
		p_handle_computer_movement(delta)

func p_handle_computer_input(_delta: float) -> void:
	algorithmOverride = "AI"
	
	match PARTNER_BEHAVIOR:
		FollowBehavior.NORMAL:
			p_global_movement()
		FollowBehavior.AGRESSIVE:
			p_finder_movement()
			p_global_movement(!player.afterSomething, !player.afterSomething)
		FollowBehavior.GREEDY:
			p_finder_movement()
			p_global_movement(!player.afterSomething, !player.afterSomething)
		FollowBehavior.FREE:
			p_free_movement()
		FollowBehavior.ENEMY:
			if (stunned):
				return
			p_enemy_movement()
	
	if (player.state_machine.get_state() == "Climb"):
		if (memoryPosition >= 0):
			algorithmOverride += " + Climbing"
			
			keyPress = leader.get_meta("thingie").inputMemoryPress[memoryPosition].duplicate()
			keyHold = leader.get_meta("thingie").inputMemoryHold[memoryPosition].duplicate()
			keyRelease = leader.get_meta("thingie").inputMemoryRelease[memoryPosition].duplicate()
	
	if (spawned):
		memoryPosition += 1

func p_handle_respawn(mode := "global") -> void:
	if (partnerState != FollowStage.RESPAWN):
		return
	if (mode != ""):
		player.direction = leader.direction
		respawnTime = PARTNER_RESPAWN_TIME
		partnerState = FollowStage.FOLLOW
	
	if (mode == "global"):
		player.teleport_player(leader.get_meta("last_safe_spot", leader.global_position), true, "Normal")
	elif (mode == "enemy"):
		if (player.global_position.y >= 256 || abs(player.playerFinder.target_position.x) >= 512):
			player.teleport_player(leader.camera_center_joint.get_node("LeftWall").global_position - Vector2(16, 0), false, "Normal")
		
	print("State changed to RESPAWN for Partner with ID: " + str(player.player_id))

func p_computer_jump(conditionPress: bool = player.is_actually_on_floor(), conditionHold := true, undoIfFalse := true) -> void:
	if (conditionPress): keyPress[INPUT.JUMP] = true
	elif (undoIfFalse): keyPress[INPUT.JUMP] = false
	if (conditionHold): keyHold[INPUT.JUMP] = true
	elif (undoIfFalse): keyHold[INPUT.JUMP] = false

func p_reset_inputs() -> void:
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

func p_finder_movement() -> void:
	if (!player.afterSomething):
		return
	
	var distanceToTarget = player.objFinder.target_position
	var isOverMe = distanceToTarget.y < -16
	var isUnderMe = distanceToTarget.y > 16
	
	keyHold[INPUT.XDIR] = sign(distanceToTarget.x)
	keyHold[INPUT.RUN] = (abs(distanceToTarget.x) > 48)
	
	if (player.fire_only):
		if (player.power_state.state_name != "Fire"):
			player.afterSomething = false
			return
		distanceToTarget = distanceToTarget.x + 48 * sign(distanceToTarget.x)
	
	# Wall close to them? No problem!
	if (player.closeToWall && !player.in_water):
		algorithmOverride += " + Close to Wall"
		p_computer_jump()
	# We gotta go higher. Unless we are not near ground.
	if (player.in_water && player.velocity.y >= 0 
	&& (abs(distanceToTarget.x) > 64 || abs(roundi(distanceToTarget.y)) >= 48) 
	&& !player.ledgeDetectionCast.is_colliding() && !player.closeToWall 
	&& abs(distanceToTarget.x) > (32 * player.player_id)):
		algorithmOverride += " + Water Swimming"
		
		keyPress[INPUT.JUMP] = leader.global_position.y > player.global_position.y
	
	if (abs(distanceToTarget.x) < 56):
		p_computer_jump(isOverMe, !isUnderMe)

var playerIsFar := false
func p_free_movement(distanceToLeader: Vector2 = -player.playerFinder.target_position) -> void:
	p_reset_inputs()
	
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
		p_global_movement(false, false)
		
		if (abs(distanceToLeader.x) < 64):
			playerIsFar = false
		return
	
	var distanceToEnd = player.global_position - flagpole.global_position
	
	keyHold[INPUT.RUN] = true
	
	keyHold[INPUT.YDIR] = 0
	keyHold[INPUT.XDIR] = -sign(distanceToEnd.x)
	if (player.closeToWall):
		p_computer_jump(true, true)
	if (player.in_water && player.velocity.y >= 0 && !player.ledgeDetectionCast.is_colliding()):
		keyPress[INPUT.JUMP] = true
	
	if (!player.is_actually_on_floor()):
		if (player.overFloor && !player.closeToWall):
			p_reset_inputs()
	
	p_global_movement(false, false)

func p_enemy_movement() -> void:
	if (flagpole == null):
		p_global_movement(false, true)
		if (player.afterSomething):
			p_throw_fire()
	else:
		var distanceToEnd = player.global_position - flagpole.global_position
		
		if (abs(distanceToEnd.x) <= 512):
			keyHold[INPUT.YDIR] = 0
			keyHold[INPUT.XDIR] = -sign(distanceToEnd.x)
			if (player.closeToWall):
				p_computer_jump()
			if (player.in_water && player.velocity.y >= 0 && !player.ledgeDetectionCast.is_colliding()):
				keyPress[INPUT.JUMP] = true
			
			if abs(distanceToEnd.x) > 96:
				keyHold[INPUT.RUN] = true
		else:
			p_global_movement(false, true)
			if (player.afterSomething):
				p_throw_fire()
	
	p_handle_respawn("enemy")

func p_throw_fire() -> void:
	keyPress[INPUT.ACTION] = true
	await get_tree().create_timer(0.1).timeout
	keyPress[INPUT.ACTION] = false
	await get_tree().create_timer(0.3).timeout

func p_global_movement(copyLeader := true, trackLeader := true) -> void:
	var distanceToLeader = -player.playerFinder.target_position
	
	if (copyLeader && leader.state_machine.get_state() != "Pipe" && memoryPosition >= 0):
		algorithmOverride += " + Copy"
		
		keyPress = leader.get_meta("thingie").inputMemoryPress[memoryPosition].duplicate()
		keyHold = leader.get_meta("thingie").inputMemoryHold[memoryPosition].duplicate()
		keyRelease = leader.get_meta("thingie").inputMemoryRelease[memoryPosition].duplicate()
	
	# ENEMY NEARBY! WE'LL HAVE TO JUMP (if in the ground, of course)!
	if (player.enemyNearby && !player.is_invincible):
		algorithmOverride += " + Enemy Nearby"
		if (player.power_state.power_tier > 1):
			keyPress[INPUT.ACTION] = true
		p_computer_jump()
	# OH NO! A PIT, QUICK WE HAVE TO JUMP (if in the ground, of course)!
	if (player.onLedge):
		algorithmOverride += " + On Ledge"
		p_computer_jump((player.is_actually_on_floor() && abs(distanceToLeader.x) > 48))
	# OH LORD! A SPRI- err ok you got the idea.
	if (player.spring_bouncing):
		algorithmOverride += " + Spring Bouncing"
		p_computer_jump(true)
	if (player.closeToWall):
		p_computer_jump()
	
	if (trackLeader):
		handle_stage_movement(distanceToLeader)
	
	if (PARTNER_BEHAVIOR != FollowBehavior.FREE
	&& !isEnemy):
		p_handle_respawn()

func handle_stage_movement(distanceToLeader: Vector2 = -player.playerFinder.target_position) -> void:
	match partnerState:
		# Near to leader, no sweat.
		FollowStage.FOLLOW:
			keyHold[INPUT.RUN] = true
			
			var leaderOnFlag := leader.state_machine.get_state() == "FlagPole" || leader.state_machine.get_state() == "Climb"
			
			var distance = (16 * player.player_id)
			if (isEnemy || leaderOnFlag):
				distance = 0
			# X distance difference check, try to go to the partner
			if (abs(distanceToLeader.x) > distance
			|| player.in_water && abs(roundi(distanceToLeader.y)) >= 48):
				algorithmOverride += " + Far Away"
				keyHold[INPUT.XDIR] = -sign(distanceToLeader.x)
				
				p_computer_jump(
					(roundi(distanceToLeader.y) >= 16 && abs(distanceToLeader.x) < 48), 
					(roundi(distanceToLeader.y) >= 8 && abs(distanceToLeader.x) < 48), true)
				
				# Wall close to them? No problem!
				if (player.closeToWall && !player.in_water):
					algorithmOverride += " + Close to Wall"
					p_computer_jump()
				# We gotta go higher. Unless we are not near ground.
				if (player.in_water && player.velocity.y >= 0 
				&& (abs(distanceToLeader.x) > 64 || abs(roundi(distanceToLeader.y)) >= 48)
				&& !player.closeToWall 
				&& abs(distanceToLeader.x) > distance):
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
				&& abs(distanceToLeader.x) <= distance && !player.onLedge):
					algorithmOverride += " + Close to partner"
					
					keyHold[INPUT.YDIR] = 0
					keyHold[INPUT.XDIR] = -sign(leader.direction)
					
					# Close to wall? No pro- ok so like, only if the leader is not nearby.
					if (player.closeToWall && (abs(distanceToLeader.x) > 32 || abs(roundi(distanceToLeader.y)) > 8)):
						algorithmOverride += " + Close to Wall"
						
						p_computer_jump()
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
						
					p_computer_jump()
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
				p_computer_jump()
			if (player.in_water && player.velocity.y >= 0 && !player.ledgeDetectionCast.is_colliding()):
				keyPress[INPUT.JUMP] = true
			
			if abs(distanceToLeader.x) > 96:
				keyHold[INPUT.RUN] = true
			
			if (!player.is_actually_on_floor()):
				if (player.overFloor && !player.closeToWall):
					p_reset_inputs()
			
			if abs(distanceToLeader.x) <= 164:
				print("State changed to FOLLOW for Partner with ID: " + str(player.player_id))
				partnerState = FollowStage.FOLLOW

func p_handle_computer_movement(_delta: float) -> void:
	if (memoryPosition >= 0):
		moves = leader.get_meta("thingie").inputMemoryMovement[memoryPosition].duplicate()
	
	if (moves[MOVE.POWER] == "Small"):
		moves[MOVE.POWER] = "0"
	elif (moves[MOVE.POWER] == "Big"):
		moves[MOVE.POWER] = "1"
	elif (moves[MOVE.POWER] == "Fire"):
		moves[MOVE.POWER] = "2"
	elif (moves[MOVE.POWER] == "Superball"):
		moves[MOVE.POWER] = "3"
		
	if (spawned):
		memoryPosition += 1
#endregion
