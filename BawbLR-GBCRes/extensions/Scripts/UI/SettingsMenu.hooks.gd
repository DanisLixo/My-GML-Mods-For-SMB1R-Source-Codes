extends Object

const RESOLUTION_CATEGORY = preload("res://mods-unpacked/BawbLR-GBCRes/Category/ResolutionCategory.tscn")

func _process(c: ModLoaderHookChain, delta: float) -> void:
	var menu := c.reference_object
	var mod_name := "gbcresolution"
	
	# Add Category if not there.
	if (!menu.get_meta(mod_name, false)):
		menu.set_meta(mod_name, true)
		
		var category := RESOLUTION_CATEGORY.instantiate()
		menu.get_node("PanelContainer/MarginContainer/VBoxContainer").add_child(category)
		
		menu.containers.append(category)
	
	c.execute_next([delta])

func handle_inputs(c: ModLoaderHookChain) -> void:
	var menu := c.reference_object
	
	c.execute_next()
	
	var direction := int(Global.multibind_action_just_pressed("ui_right")) - int(Global.multibind_action_just_pressed("ui_left"))
	while menu.disabled_containers.has(menu.containers[menu.category_index]):
		menu.category_index = wrap(menu.category_index + direction, 0, menu.containers.size())
	menu.current_container = menu.containers[menu.category_index]
