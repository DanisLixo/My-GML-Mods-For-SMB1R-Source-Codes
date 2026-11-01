extends HBoxContainer

@export var title := ""
@export var values: Array[String] = []
@export var value_descs: Array[String] = []
@export var player_id := 1

var selected := false
var character_icons := []
signal value_changed(new_value, player_id)

var selected_index := 0
var maximum_idx := values.size()

func _ready() -> void:
	await get_tree().process_frame
	
	title = title.replace("player_id", str(player_id))
	update_starting_values(true)
	
	show()

func _process(_delta: float) -> void:
	if (Settings.file.partners.follow_mode == 1):
		maximum_idx = 1
	else:
		maximum_idx = values.size() - 1
	
	if selected:
		handle_inputs()
		grab_focus()
	$Cursor.modulate.a = int(selected)
	for i in [$AutoScrollContainer, $HBoxContainer/AutoScrollContainer]:
		i.is_focused = selected
	%Title.text = tr(title) + ":"
	%Value.text = tr(str(values[selected_index]))
	%LeftArrow.modulate.a = int(selected and selected_index > 0)
	%RightArrow.modulate.a = int(selected and selected_index < maximum_idx)
	
	if (owner != null):
		if (owner.active):
			update_starting_values()

func update_starting_values(load_global := false) -> void:
	%BehaviorIcon.region_rect.position.x = (8.0 * selected_index)
	%BehaviorIcon.region_rect.position.y = (8.0 * Settings.file.partners.follow_mode)

	if (load_global):
		selected_index = Settings.file.partners.behavior[player_id]
	
	if (GameHUD.character_icons[int(selected_index)] != null):
		%CharacterIcon.get_node("ResourceSetterNew").json_path = GameHUD.character_icons[int(Global.player_characters[player_id])]
	%PlayerColourTexture.json_path = Player.CHARACTER_COLOURS[int(Global.player_characters[player_id])]
	$HBoxContainer/AutoScrollContainer/Value/TextShadowColourChanger.handle_shadow_colours()

func set_selected(active := false) -> void:
	selected = active

func handle_inputs() -> void:
	var old := selected_index
	if Input.is_action_just_pressed("ui_left"):
		selected_index -= 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	if Input.is_action_just_pressed("ui_right"):
		selected_index += 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	selected_index = clamp(selected_index, 0, maximum_idx)
	if old != selected_index:
		grab_focus()
		value_changed.emit(selected_index, player_id)
