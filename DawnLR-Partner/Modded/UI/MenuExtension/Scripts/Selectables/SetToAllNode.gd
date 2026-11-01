extends HBoxContainer

@export var title := ""
@export var values: Array[String] = []
@export var value_descs: Array[String] = []

signal decided(value: int)
var confirming := false

var selected := false
var selected_index := 0
var maximum_idx := values.size()

func _process(_delta: float) -> void:
	if (Settings.file.partners.follow_mode == 1):
		maximum_idx = 1
		value_descs[1] = "THEY WILL BECOME DEADLY COSMIC CLONES. DON'T TOUCH THEM."
	else:
		maximum_idx = values.size() - 1
		value_descs[1] = "THEY WILL FOLLOW YOU TO KILL YOU, DON'T TOUCH THEM."
	if selected:
		handle_inputs()
		grab_focus()
	$Cursor.modulate.a = int(selected)
	for i in [$AutoScrollContainer, %AutoScrollContainer2]:
		i.is_focused = selected
	%Title.text = tr(title) + ":"
	if not confirming:
		%Value.modulate = Color.WHITE
		%Value.text = tr(str(values[selected_index]))
	else:
		%Value.text = tr("DELETION_CONFIRM")
		%Value.modulate = Color.RED
	%LeftArrow.modulate.a = int(selected and selected_index > 0)
	%RightArrow.modulate.a = int(selected and selected_index < maximum_idx)
	$VBoxContainer/HBoxContainer/VSeparator.visible = !confirming
	%BehaviorIcon.visible = !confirming
	%BehaviorIcon.region_rect.position.x = (8.0 * selected_index)
	%BehaviorIcon.region_rect.position.y = (8.0 * Settings.file.partners.follow_mode)

func set_selected(active := false) -> void:
	selected = active

func handle_inputs() -> void:
	if Global.multibind_action_just_pressed("ui_left"):
		confirming = false
		selected_index -= 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	if Global.multibind_action_just_pressed("ui_right"):
		confirming = false
		selected_index += 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
			
	selected_index = clamp(selected_index, 0, maximum_idx)
	
	if Global.multibind_action_just_pressed("ui_accept"):
		if confirming:
			AudioManager.play_global_sfx("cannon")
			confirming = false
			decided.emit(selected_index)
		else:
			confirming = true
