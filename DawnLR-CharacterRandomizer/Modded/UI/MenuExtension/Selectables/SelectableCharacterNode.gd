extends HBoxContainer

@onready var RandomizerSettings = Settings.get_meta("RandomizerMod")

@export var title := "Add Character"

var can_select := true
var selected := false
signal value_changed(new_value: int)

var selected_index := -1:
	set(value):
		var direction = signi(value - selected_index)
		
		selected_index = wrapi(value, 0, Player.CHARACTERS.size())
		if (can_select):
			while (owner.unavailable_values.has(selected_index)):
				if (owner.unavailable_values.size() >= Player.CHARACTERS.size()):
					break
				selected_index = wrapi(selected_index + direction, 0, Player.CHARACTERS.size())
		update()

func _process(_delta: float) -> void:
	if selected:
		can_select = owner.mode == 0 || (owner.mode == 1 && owner.unavailable_values.size() < Player.CHARACTERS.size())
		handle_inputs()
		grab_focus()
	$Cursor.modulate.a = int(selected)
	for i in [$AutoScrollContainer, $HBoxContainer/AutoScrollContainer]:
		i.is_focused = selected
	%Title.text = tr(title) + ":"
	%Value.text = tr(str(Player.CHARACTER_NAMES[selected_index]))
	if (!can_select):
		%Value.text = "THEY ALL GONE WHAT!!!!!!!!"
		%CharacterIcon.hide()
		$HBoxContainer/VSeparator.hide()
		if (owner.mode == 1 && owner.unavailable_values.size() < Player.CHARACTERS.size()):
			%Value.text = "Oh dang..."
	else:
		%CharacterIcon.show()
		$HBoxContainer/VSeparator.show()
		
	%LeftArrow.modulate.a = int(selected)
	%RightArrow.modulate.a = int(selected)

func update() -> void:
	show()
	
	if (GameHUD.character_icons[int(selected_index)] != null):
		%CharacterIcon.get_node("ResourceSetterNew").json_path = GameHUD.character_icons[int(selected_index)]
	%PlayerColourTexture.json_path = Player.CHARACTER_COLOURS[selected_index]
	$HBoxContainer/AutoScrollContainer/Value/TextShadowColourChanger.handle_shadow_colours()

func set_selected(active := false) -> void:
	selected = active

func handle_inputs() -> void:
	var direction := int(Global.multibind_action_just_pressed("ui_right")) - int(Global.multibind_action_just_pressed("ui_left"))
	
	if (direction != 0):
		selected_index += direction
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	
	if Global.multibind_action_just_pressed("ui_accept") && can_select:
		grab_focus()
		value_changed.emit(selected_index)
		if (owner.mode == 1):
			selected_index += 1
			update()
