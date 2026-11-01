extends Control

@onready var RandomizerSettings = Settings.get_meta("RandomizerMod")
@onready var lists := ["user_character_list", "excluded_characters"]
@onready var current_container := %Selector

signal closed
signal opened

@export var mode := 0

var unavailable_values := []

func _ready() -> void:
	close(false)

func _process(_delta: float) -> void:
	if Global.multibind_action_just_pressed("ui_back") && !current_container.editing_list:
		close()

func open() -> void:
	%ListNode.generate_list(RandomizerSettings.file.options[lists[mode]])
	
	show()
	opened.emit()
	
	await get_tree().process_frame
	$PanelContainer/MarginContainer/VBoxContainer/Selector/AddCharacter.selected_index = 0
	current_container.can_input = true
	set_process(true)

func close(save := true) -> void:
	hide()
	closed.emit()
	
	await get_tree().process_frame
	current_container.can_input = false
	set_process(false)
	
	if (save):
		RandomizerSettings.file.options[lists[mode]] = %ListNode.current_list.duplicate()
		RandomizerSettings.save_settings()
