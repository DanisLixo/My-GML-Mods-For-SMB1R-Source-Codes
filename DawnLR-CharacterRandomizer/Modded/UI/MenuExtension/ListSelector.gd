extends "res://Scripts/UI/SettingsCategory.gd"

@export var character_list: Array[Control]
@onready var current_options := options

var editing_list := false

func _process(_delta: float) -> void:
	visible = active
	
	for i in options:
		if (i != null):
			i.selected = false
	for i in character_list:
		if (i != null):
			i.selected = false
	
	var idx := 0
	for i in current_options:
		if i != null:
			i.selected = selected_index == idx and active and can_input
			idx += 1
	
	if (character_list.is_empty() && editing_list):
		toggle_list_editing()
	
	if (!active):
		selected_index = minimum_idx
	else:
		if (can_input):
			handle_input()
		if (description_node != null):
			handle_description()
		if (scroll_container != null):
			handle_scroll_container()

func handle_input() -> void:
	if (editing_list):
		if (Global.multibind_action_just_pressed("ui_back")):
			toggle_list_editing()
	
	var old_idx := selected_index
	if Global.multibind_action_just_pressed("ui_down"):
		selected_index += 1
	if Global.multibind_action_just_pressed("ui_up"):
		selected_index -= 1
	selected_index = clampi(selected_index, minimum_idx, current_options.size() - 1)
	if old_idx != selected_index:
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
		current_options[selected_index].grab_focus()

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

func on_remove_pressed() -> void:
	if (character_list.is_empty()):
		AudioManager.play_global_sfx("bump")
		return
	
	AudioManager.play_global_sfx("beep")
	toggle_list_editing()

var saved_index := [0, 0]
func toggle_list_editing() -> void:
	saved_index[int(editing_list)] = selected_index
	editing_list = !editing_list
	
	current_options = character_list if (editing_list) else options
	selected_index = clampi(saved_index[int(editing_list)], minimum_idx, current_options.size() - 1)
