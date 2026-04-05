extends HBoxContainer

@onready var PartnerSettings = get_node("/root/ModLoader/DawnLR-Partner/PartnerSettingsManager")

@export var settings_category := "video"
@export var option_key := ""
@export var title := ""
@export var values := []
@export var value_descs: Array[String] = []

var selected := false

signal value_changed(new_value)

var selected_index := 0

func _ready() -> void:
	update_starting_values()

func update_starting_values() -> void:
	if PartnerSettings.file.has(settings_category):
		if PartnerSettings.file[settings_category].has(option_key):
			if PartnerSettings.file[settings_category][option_key] is String:
				selected_index = values.find(PartnerSettings.file[settings_category][option_key])
			else:
				selected_index = PartnerSettings.file[settings_category][option_key]

func _process(_delta: float) -> void:
	if selected:
		handle_inputs()
		grab_focus()
	$Cursor.modulate.a = int(selected)
	for i in [$AutoScrollContainer, %AutoScrollContainer2]:
		i.is_focused = selected
	%Title.text = tr(title) + ":"
	%Value.text = tr(str(values[selected_index]))
	%LeftArrow.modulate.a = int(selected and selected_index > 0)
	%RightArrow.modulate.a = int(selected and selected_index < values.size() - 1)

func set_selected(active := false) -> void:
	selected = active

func handle_inputs() -> void:
	var old := selected_index
	if Global.multibind_action_just_pressed("ui_left"):
		selected_index -= 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	if Global.multibind_action_just_pressed("ui_right"):
		selected_index += 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	selected_index = clamp(selected_index, 0, values.size() - 1)
	if old != selected_index:
		value_changed.emit(selected_index)
