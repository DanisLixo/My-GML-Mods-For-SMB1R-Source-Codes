extends Object

func handle_animations(chain: ModLoaderHookChain) -> void:
	chain.execute_next()
	var refobj = chain.reference_object
	var animation = refobj.get_animation_name()
	
	if refobj.player.power_state.state_name == "Shell":
		if ["CrouchMove", "CrouchBump", "CrouchFall", "CrouchJump", "Crouch"].has(animation):
			refobj.player.sprite.speed_scale = refobj.player.velocity.x / 80

func physics_update(chain: ModLoaderHookChain, delta):
	chain.execute_next([delta])

func get_animation_name(chain: ModLoaderHookChain) -> String:
	var refobj = chain.reference_object
	
	if refobj.player.power_state.state_name == "Shell":
		if refobj.player.power_state.sliding == true:
			return "Crouch"
	return chain.execute_next()
