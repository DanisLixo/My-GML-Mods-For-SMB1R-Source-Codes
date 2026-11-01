extends Object

## PackedScene for category
const RANDOMIZER_CATEGORY = preload("res://mods-unpacked/DawnLR-CharacterRandomizer/Modded/UI/MenuExtension/RandomizerCategory.tscn")
const LIST_EDITOR = preload("res://mods-unpacked/DawnLR-CharacterRandomizer/Modded/UI/MenuExtension/ListEditor.tscn")

func _process(c: ModLoaderHookChain, delta: float) -> void:
	var menu := c.reference_object
	var mod_name := "randomizer"
	
	# Add Category if not there.
	if (!menu.get_meta(mod_name, false)):
		var category := RANDOMIZER_CATEGORY.instantiate()
		menu.get_node("PanelContainer/MarginContainer/VBoxContainer").add_child(category)
		
		menu.containers.append(category)
		
		menu.closed.connect(category.get_node("%InputMapApplier").save_inputs)
		
		# If you want the category to be inaccessable in a playthrough.
		#if (menu.owner.has_method("open_settings")):
		#	menu.disabled_containers.append(partners_category)
		
		# Add extra stuff and interactions...
		
		var editor := LIST_EDITOR.instantiate()
		menu.add_child(editor)
		category.open_custom_list.connect(func():
			menu.can_move = false
			editor.mode = 0
			editor.open())
		category.open_excluded_list.connect(func():
			menu.can_move = false
			editor.mode = 1
			editor.open())
			
		editor.closed.connect(func(): menu.can_move = true)
		
		menu.set_meta(mod_name, true)
	
	c.execute_next([delta])

func handle_inputs(c: ModLoaderHookChain) -> void:
	var menu := c.reference_object
	
	c.execute_next()
	
	var direction := int(Global.multibind_action_just_pressed("ui_right")) - int(Global.multibind_action_just_pressed("ui_left"))
	while menu.disabled_containers.has(menu.containers[menu.category_index]):
		menu.category_index = wrap(menu.category_index + direction, 0, menu.containers.size())
	menu.current_container = menu.containers[menu.category_index]
