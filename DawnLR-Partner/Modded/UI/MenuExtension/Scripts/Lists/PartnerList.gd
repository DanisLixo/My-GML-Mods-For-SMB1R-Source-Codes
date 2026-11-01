extends VBoxContainer

@export var myCategory: Control

var options: Array[Control] = []
var can_input := true

signal options_changed(options: Array[Control])

var current_idx := 0

func update(menu_only := false) -> void:
	update_partner_options(Settings.file.partners.amount, menu_only)

func _process(_delta: float) -> void:
	owner.can_move = can_input
	
	$HSeparator.visible = options.size() > 0

func auto_get_options() -> void:
	options.clear()
	for i in get_children():
		if i is HBoxContainer || i is VBoxContainer:
			if (i not in myCategory.options):
				options.append(i)

var partnerOptionScene: PackedScene = preload("res://mods-unpacked/DawnLR-Partner/Modded/UI/MenuExtension/Scenes/Selectables/SelectablePartnerOption.tscn")
func update_partner_options(new_value: int, menuOnly: bool = false) -> void:
	var old_size = options.size() 
	
	if (old_size == new_value): 
		return
	elif (new_value > old_size):
		while options.size() < new_value:
			current_idx = wrapi(current_idx + 1, 0, Player.CHARACTERS.size())
			add_partner_option((new_value >= 4 && !menuOnly), !menuOnly)
	else:
		while options.size() > new_value:
			current_idx = wrapi(current_idx - 1, 0, Player.CHARACTERS.size())
			remove_partner_option((new_value >= 3 && !menuOnly))
	
	await get_tree().physics_frame
	auto_get_options()
	if (!menuOnly):
		Settings.file.partners.characters = Global.player_characters
		Settings.save_settings()
	
	options_changed.emit(options)

func add_partner_option(add_to_global: bool = false, override_global_value: bool = true) -> void:
	var new_value = options.size() + 1
	
	if (add_to_global):
		Global.player_characters.push_back(current_idx)
	elif (override_global_value):
		Global.player_characters[new_value] = current_idx
	
	var newOpt = partnerOptionScene.instantiate()
	newOpt.title = "PARTNER player_id"
	newOpt.value_changed.connect(%ConfigSelector.a_partner_id_changed)
	newOpt.player_id = new_value
	newOpt.hide()
	add_child(newOpt)
	
	newOpt.owner = myCategory 
	options.push_back(newOpt)

func remove_partner_option(remove_from_global: bool = false) -> void:
	var new_value = options.size() - 1
	if (options[new_value] != null):
		options[new_value].queue_free()
	options.resize(new_value)
	if (remove_from_global):
		Global.player_characters.resize(new_value + 1)
	else:
		Global.player_characters[new_value + 1] = -1
