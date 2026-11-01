extends Control

var category_select_active := false
var category_index := 0

@export var containers: Array[Control]
@onready var activeContainers: Array[Control] = containers.duplicate()
@onready var currentContainer: Control = activeContainers[0]

var active := false
var can_move := true

signal opened
signal closed

func _ready() -> void:
	close()
	
	%PartnerList.update(true)
	%BehaviorList.update(true)

func _process(_delta: float) -> void:
	category_select_active = (currentContainer.selected_index == -1 && active)
	%Category.text = tr(currentContainer.category_name)
	
	for i in [%LeftArrow, %RightArrow]:
		i.modulate.a = int(currentContainer.selected_index == -1)
	for i in activeContainers.size():
		activeContainers[i].active = (category_index == i && active)
		activeContainers[i].can_input = can_move
	
	if active and can_move && currentContainer.can_input:
		handle_inputs()

func handle_inputs() -> void:
	if Global.multibind_action_just_pressed("ui_back"):
		close()
	
	if (category_select_active):
		if Global.multibind_action_just_pressed("ui_left"):
			category_index -= 1
			if Settings.file.audio.extra_sfx == 1:
				AudioManager.play_global_sfx("menu_move")
		if Global.multibind_action_just_pressed("ui_right"):
			category_index += 1
			if Settings.file.audio.extra_sfx == 1:
				AudioManager.play_global_sfx("menu_move")
		category_index = wrap(category_index, 0, activeContainers.size())
		
		currentContainer = activeContainers[category_index]

func open() -> void:
	show()
	opened.emit()
	
	await get_tree().process_frame
	active = true
	
	for i in containers:
		i.active = false
	
	%PartnerList.update()
	%BehaviorList.update()

func update_partner_options(new_value: int) -> void:
	%PartnerList.update_partner_options(new_value)
	%BehaviorList.update_behavior_options(new_value)

func close() -> void:
	active = false
	hide()
	closed.emit()
