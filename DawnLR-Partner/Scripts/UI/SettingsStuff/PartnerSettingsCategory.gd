extends VBoxContainer

@export var category_name := "Hi"
@export var options: Array[Control] = []
@export var minimum_idx := -1
@export var description_node: Control = null
@export var disappear_at := -1
@export var scroll_container: ScrollContainer = null
@export var scroll_step := 8

@onready var actualOptions: Array[Control] = options.duplicate()
@onready var active := true
var selected_index := -1
var can_input := true

func _process(_delta: float) -> void:
	visible = active
	if active and can_input:
		handle_input()
	var idx := 0
	for i in actualOptions:
		if i != null:
			i.selected = selected_index == idx and active
			idx += 1
	if description_node != null:
		if (selected_index >= 0 and actualOptions[selected_index] != null):
			var description: String = actualOptions[selected_index].value_descs[actualOptions[selected_index].selected_index]
			if (actualOptions[selected_index].get("selectMode") != null):
				description = actualOptions[selected_index].value_descs
			description_node.text = description
		else:
			description_node.text = ""
	if description_node != null && disappear_at != -1:
		get_node("Description").visible = selected_index < disappear_at
	if not active:
		selected_index = minimum_idx

func handle_input() -> void:
	if Input.is_action_just_pressed("ui_down"):
		selected_index += 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	if Input.is_action_just_pressed("ui_up"):
		selected_index -= 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	if scroll_container != null:
		scroll_container.scroll_vertical = float(lerpf(0.0, scroll_container.get_v_scroll_bar().max_value, inverse_lerp(0.0, options.size() - 1, selected_index - 2)))
	selected_index = clamp(selected_index, minimum_idx, actualOptions.size() - 1)

func update_options(list: Array[Control] = []) -> void:
	actualOptions = options.duplicate()
	for i in list:
		actualOptions.append(i)
