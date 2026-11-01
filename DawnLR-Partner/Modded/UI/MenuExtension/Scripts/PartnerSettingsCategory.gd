extends VBoxContainer
@export var category_name := "Hi"
@export var options: Array[Control] = []
@export var minimum_idx := -1

@export var description_node: Control = null
@export var disappear_at := -1

@export var scroll_container: ScrollContainer = null
@export var scroll_step := 8

@onready var active := true
@onready var visible_options := options.duplicate()

var selected_index := -1
var can_input := true

signal show_limit_popup
signal show_setup_popup

func _ready() -> void:
	owner = get_parent().owner
	
	update_options(Settings.file.partners.follow_mode)

func _process(_delta: float) -> void:
	visible = active
	
	if (visible && visible_options.is_empty()):
		update_options(Settings.file.partners.follow_mode)
	
	var idx := 0
	for i in visible_options:
		if i != null:
			i.selected = selected_index == idx and active
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

func handle_input() -> void:
	var direction := int(Global.multibind_action_just_pressed("ui_down")) - int(Global.multibind_action_just_pressed("ui_up"))
	if direction != 0:
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	
	selected_index = clamp(selected_index + direction, minimum_idx, visible_options.size() - 1)

func handle_description() -> void:
	var current_option = visible_options[selected_index]
	
	var value_desc = current_option.get("value_descs")
	
	if (value_desc == null):
		value_desc = ""
	if (value_desc is Array):
		if (!value_desc.is_empty()):
			value_desc = value_desc[current_option.selected_index]
		else:
			value_desc = ""
	
	get_node("HSeparator").visible = (!(value_desc.is_empty()) && ((disappear_at != -1 && selected_index < disappear_at) || selected_index != -1))
	get_node("Description").visible = (!(value_desc.is_empty()) && ((disappear_at != -1 && selected_index < disappear_at) || selected_index != -1))
	
	if (description_node.is_visible_in_tree() && selected_index >= 0 && current_option != null):
		description_node.text = value_desc

func handle_scroll_container() -> void:
	scroll_container.follow_focus = selected_index > minimum_idx
	if selected_index <= minimum_idx:
		scroll_container.scroll_vertical = 0

func update_options(new_value: Variant) -> void:
	if (owner.get_node_or_null("CanvasLayer")):
		for i in %CPU.get_children():
			%CPU.visible = !new_value
			i.visible = !new_value
		for i in %COPY.get_children():
			%COPY.visible = !new_value
			i.visible = new_value
	
	visible_options.clear()
	
	for opt in options:
		if (opt.visible):
			visible_options.append(opt)
		
	if (new_value is Array):
		visible_options.append_array(new_value)

func show_limit_warning(_new_value: Variant) -> void:
	if (!Global.get_meta("partners_warning", false)):
		if (!Settings.file.partners.unlock_limit):
			show_limit_popup.emit()
		Global.set_meta("partners_warning", true)

func show_setup_menu() -> void:
	show_setup_popup.emit()
	
	owner.can_move = false

signal amount_resized(new_value: int)
func amount_changed(new_value: Variant) -> void:
	amount_resized.emit(new_value)
