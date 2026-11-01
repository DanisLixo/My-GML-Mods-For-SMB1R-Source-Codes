extends VBoxContainer

@onready var RandomizerSettings = Settings.get_meta("RandomizerMod")

var selected := false
signal item_selected(item: VBoxContainer)

var selected_index := 0

func _ready() -> void:
	update()

func _process(_delta: float) -> void:
	if selected:
		handle_inputs()
	%Cursor.modulate.a = int(selected)
	for i in [%AutoScrollContainer]:
		i.is_focused = selected
	%Value.text = tr(str(Player.CHARACTER_NAMES[selected_index]))

func update() -> void:
	show()
	
	if (selected_index == -1):
		%CharacterIcon.get_node("ResourceSetterNew").json_path = ""
		return
	
	if (GameHUD.character_icons[int(selected_index)] != null):
		%CharacterIcon.get_node("ResourceSetterNew").json_path = GameHUD.character_icons[int(selected_index)]
	%PlayerColourTexture.json_path = Player.CHARACTER_COLOURS[selected_index]
	%TextShadowColourChanger.handle_shadow_colours()

func set_selected(active := false) -> void:
	selected = active

func handle_inputs() -> void:
	if Global.multibind_action_just_pressed("ui_accept"):
		item_selected.emit(self)
