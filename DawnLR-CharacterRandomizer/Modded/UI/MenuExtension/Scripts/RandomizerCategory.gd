extends "res://Scripts/UI/SettingsCategory.gd"

func _process(_delta: float) -> void:
	visible = active
	
	var idx := 0
	for i in options:
		if i != null:
			i.selected = selected_index == idx and active and can_input
			idx += 1
	
	if (!active):
		selected_index = minimum_idx
	else:
		if (can_input):
			handle_input()
		if (description_node != null):
			handle_description()
		if (scroll_container != null):
			handle_scroll_container()

func handle_description() -> void:
	var current_option = options[selected_index]
	
	var value_desc = current_option.get("value_descs")
	
	if (value_desc == null):
		value_desc = ""
	if (value_desc is Array):
		if (!value_desc.is_empty()):
			value_desc = value_desc[current_option.selected_index]
		else:
			value_desc = ""
			
	if (description_node.is_visible_in_tree() && selected_index >= 0 && current_option != null):
		description_node.text = value_desc

func handle_scroll_container() -> void:
	scroll_container.follow_focus = selected_index > minimum_idx
	if selected_index <= minimum_idx:
		scroll_container.scroll_vertical = 0

signal open_custom_list
func custom_list_pressed() -> void:
	open_custom_list.emit()

signal open_excluded_list
func excluded_list_pressed() -> void:
	open_excluded_list.emit()
