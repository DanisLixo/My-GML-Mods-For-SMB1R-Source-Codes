extends HBoxContainer

@onready var PartnerSettings = get_node("/root/ModLoader/DawnLR-Partner/PartnerSettingsManager")

@export var title := ""
@export var player_id := 1

var selected := false
var character_icons := []
signal value_changed(new_value, player_id)

var selected_index := 0

func _ready() -> void:
	await get_tree().process_frame
	
	title = title.replace("player_id", str(player_id))
	update_starting_values(true)
	
	show()

func _process(_delta: float) -> void:
	if selected:
		handle_inputs()
		grab_focus()
	$Cursor.modulate.a = int(selected)
	for i in [$AutoScrollContainer, $HBoxContainer/AutoScrollContainer]:
		i.is_focused = selected
	%Title.text = tr(title) + ":"
	%Value.text = tr(str(Player.CHARACTER_NAMES[selected_index]))
	%LeftArrow.modulate.a = int(selected)
	%RightArrow.modulate.a = int(selected)

func update_starting_values(load_global := false) -> void:
	if (load_global):
		selected_index = Global.player_characters[player_id]
	
	%CharacterIcon.get_node("ResourceSetterNew").resource_json = (GameHUD.character_icons[selected_index])
	%PlayerColourTexture.resource_json = Player.CHARACTER_COLOURS[selected_index]
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
	selected_index = wrap(selected_index, 0, Player.CHARACTERS.size() - 1)
	
	if old != selected_index:
		grab_focus()
		
		update_starting_values()
		value_changed.emit(selected_index, player_id)
