extends Object

const PARTNERS_CATEGORY = preload("res://mods-unpacked/DawnLR-Partner/Modded/UI/MenuExtension/Scenes/Categories/PartnersCategoryNew.tscn")
const LIMIT_WARNING_PANEL = preload("res://mods-unpacked/DawnLR-Partner/Modded/UI/MenuExtension/Scenes/Popups/LimitWarningPanel.tscn")
const PARTNERS_SELECTOR = preload("res://mods-unpacked/DawnLR-Partner/Modded/UI/MenuExtension/Scenes/Popups/PartnersSelector.tscn")

func _process(c: ModLoaderHookChain, delta: float) -> void:
	var menu := c.reference_object
	var mod_name := "partners"
	
	# Add Category if not there.
	if (!menu.get_meta(mod_name, false)):
		var partners_category := PARTNERS_CATEGORY.instantiate()
		menu.get_node("PanelContainer/MarginContainer/VBoxContainer").add_child(partners_category)
		
		menu.containers.append(partners_category)
		
		# If you want the category to be inaccessable in a playthrough.
		if (menu.owner.has_method("open_settings")):
			menu.disabled_containers.append(partners_category)
		
		# Add extra stuff and interactions...
		
		var amount_limit_warning = LIMIT_WARNING_PANEL.instantiate()
		menu.add_child(amount_limit_warning)
		
		var partners_setup_menu = PARTNERS_SELECTOR.instantiate()
		menu.add_child(partners_setup_menu)
		
		partners_category.show_limit_popup.connect(
			func():
				AudioManager.play_global_sfx("bump")
				menu.can_move = false
				amount_limit_warning.show())
		
		partners_category.show_setup_popup.connect(
			func():
				menu.can_move = false
				partners_setup_menu.open())
		
		partners_category.amount_resized.connect(partners_setup_menu.update_partner_options)
		
		amount_limit_warning.closed.connect(func(): menu.can_move = true)
		partners_setup_menu.closed.connect(func(): menu.can_move = true)
		
		menu.set_meta(mod_name, true)
	
	c.execute_next([delta])

func handle_inputs(c: ModLoaderHookChain) -> void:
	var menu := c.reference_object
	
	c.execute_next()
	
	var direction := int(Global.multibind_action_just_pressed("ui_right")) - int(Global.multibind_action_just_pressed("ui_left"))
	while menu.disabled_containers.has(menu.containers[menu.category_index]):
		menu.category_index = wrap(menu.category_index + direction, 0, menu.containers.size())
	menu.current_container = menu.containers[menu.category_index]
