extends VBoxContainer

@export var myCategory: Control

var options: Array[Control] = []

signal options_changed(options: Array[Control])

@onready var PartnerSettings = get_node("/root/ModLoader/DawnLR-Partner/PartnerSettingsManager")
func _ready() -> void:
	await get_tree().process_frame
	update_behavior_options(PartnerSettings.file.selector.amount, true)

func _process(_delta: float) -> void:
	$HSeparator.visible = options.size() > 0

func auto_get_options() -> void:
	options.clear()
	for i in get_children():
		if i is HBoxContainer || i is VBoxContainer:
			if (i not in myCategory.options):
				options.append(i)

var partnerOptionScene: PackedScene = preload("res://mods-unpacked/DawnLR-Partner/Scenes/UI/SettingsStuff/Selectables/SelectableBehaviorOption.tscn")
func update_behavior_options(new_value: int, menuOnly: bool = false) -> void:
	var old_size = options.size()
	
	if (old_size == new_value): 
		return
	elif (new_value > old_size):
		while options.size() < new_value:
			add_partner_option((new_value >= 4 && !menuOnly), !menuOnly)
	else:
		while options.size() > new_value:
			remove_partner_option((new_value >= 3 && !menuOnly))
	
	await get_tree().physics_frame
	auto_get_options()
	if (!menuOnly):
		PartnerSettings.save_settings()
	
	options_changed.emit(options)

func add_partner_option(add_to_global: bool = false, override_global_value: bool = true) -> void:
	var new_value = options.size() + 1
	if (add_to_global):
		PartnerSettings.file.selector.behavior.push_back(0)
	elif (override_global_value):
		PartnerSettings.file.selector.behavior[new_value] = 0
	
	var newOpt = partnerOptionScene.instantiate()
	newOpt.title = "PARTNER player_id"
	newOpt.value_changed.connect(%ConfigBehavior.a_partner_behavior_changed)
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
		PartnerSettings.file.selector.behavior.resize(new_value + 1)
	else:
		PartnerSettings.file.selector.behavior[new_value + 1] = -1

func on_decided(value: int) -> void:
	for i in options:
		i.selected_index = value
		i.value_changed.emit(value, i.player_id)
