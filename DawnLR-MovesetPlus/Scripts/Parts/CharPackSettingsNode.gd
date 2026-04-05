extends Node

@export var actualSettings: Control
@export var tipText = "Character have a resource pack! \n Press ui_up to open settings."
@export var tipTextShort = "Character have a resource pack!"

var charSelect: Control
var charHasPack := false
var charHasConfig := false
var selected = Global.player_characters[0]

func _ready() -> void:
	actualSettings.opened.connect(func (): charSelect.active = false)
	actualSettings.closed.connect(func (): charSelect.active = true)
	
	get_character_pack()

func _process(_delta: float) -> void:
	$TipText.visible = (charHasPack || charHasConfig) && charSelect.active
	
	if (selected != charSelect.selected_index):
		selected = charSelect.selected_index
		get_character_pack()
	
	if (Input.is_action_just_pressed("ui_up") && !actualSettings.active && charSelect.active && charHasConfig):
		actualSettings.open()

func get_character_pack() -> void:
	if (charSelect == null): return
	
	actualSettings.json_path = ""
	actualSettings.config_json = {}
	actualSettings.selected_index = selected
	
	var pack_info = Global.config_path.path_join("custom_characters/" + Player.CHARACTERS[charSelect.selected_index] + "/Assets")
	charHasPack = DirAccess.get_directories_at(pack_info).size() != 0
	
	var pack_config = Global.config_path.path_join("custom_characters/" + Player.CHARACTERS[charSelect.selected_index] + "/Assets/config.json")
	charHasConfig = FileAccess.file_exists(pack_config)
	
	if FileAccess.file_exists(pack_config):
		var file = FileAccess.open(pack_config, FileAccess.READ)
		var json = JSON.parse_string(file.get_as_text())
		actualSettings.json_path = pack_config
		actualSettings.config_json = json
		file.close()
