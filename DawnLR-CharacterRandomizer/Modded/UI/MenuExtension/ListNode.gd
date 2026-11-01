extends Node

@onready var RandomizerSettings = Settings.get_meta("RandomizerMod")

const CHARACTER_ITEM_LIST = preload("res://mods-unpacked/DawnLR-CharacterRandomizer/Modded/UI/MenuExtension/Selectables/CharacterItemList.tscn")

var current_list := []

func generate_list(list := []) -> void:
	clear_list()
	
	for chara_id in list:
		var chara_idx := Player.CHARACTERS.find(chara_id)
		
		current_list.append(chara_id)
		create_selectable_item_list(chara_idx)

func create_selectable_item_list(idx: int) -> void:
	%NoCharas.hide()
	
	var item := CHARACTER_ITEM_LIST.instantiate()
	item.selected_index = idx
	item.item_selected.connect(remove_from_list)
	
	owner.unavailable_values.append(idx)
	%Selector.character_list.append(item)
	%List.add_child(item)

func add_to_list(chara_id: int) -> void:
	current_list.append(Player.CHARACTERS[chara_id])
	
	create_selectable_item_list(chara_id)

func remove_from_list(container: VBoxContainer) -> void:
	owner.unavailable_values.erase(container.selected_index)
	current_list.erase(Player.CHARACTERS[container.selected_index])
	%Selector.character_list.erase(container)
	container.queue_free()
	
	if (%Selector.character_list.is_empty()):
		clear_list()

func on_clear_list(_campaign: String = "") -> void:
	clear_list()

func clear_list() -> void:
	%NoCharas.show()
	
	for i in %Selector.character_list:
		i.free()
	
	owner.unavailable_values.clear()
	%Selector.character_list.clear()
	current_list.clear()
