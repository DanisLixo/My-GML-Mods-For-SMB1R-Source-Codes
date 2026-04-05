extends Control

@onready var currentContainer: Control = $PanelContainer/MarginContainer/VBoxContainer/CPUOptions
@onready var PartnerSettings = get_node("/root/ModLoader/DawnLR-Partner/PartnerSettingsManager")

var categorySelectActive := false
var categoryIndex := 0

@export var containers: Array[Control]

@onready var categoryNotShowing: Control = containers[2]
@onready var activeContainers: Array[Control] = containers.duplicate()

var active := false
var canMove := true
static var limitWarningShown := false

signal opened
signal closed

func _ready() -> void:
	var amountOption = $PanelContainer/MarginContainer/VBoxContainer/Selector/ScrollContainer/PartnerList/PartnersAmount
	if (PartnerSettings.file.selector.unlock_limit == 1):
		amountOption.maximum = INF
		limitWarningShown = true
	if (PartnerSettings.file.selector.follow_mode == 0):
		categoryNotShowing = containers[3]
	
	activeContainers.erase(categoryNotShowing)
	
	print(str(get_parent()))
	
	opened.connect(get_parent().ablueh)
	closed.connect(get_parent().open)

func _process(_delta: float) -> void:
	categorySelectActive = (currentContainer.selected_index == -1 && active)
	%Category.text = tr(currentContainer.category_name)
	
	for i in [%LeftArrow, %RightArrow]:
		i.modulate.a = int(currentContainer.selected_index == -1)
	
	for i in activeContainers.size():
		activeContainers[i].active = (categoryIndex == i && active)
		activeContainers[i].can_input = canMove
	if categorySelectActive and active and canMove:
		handle_inputs()
	if Global.multibind_action_just_pressed("ui_accept"):
		$CanvasLayer.hide()
	if Input.is_action_just_pressed("ui_back") && active && currentContainer.can_input and canMove:
		close()

func handle_inputs() -> void:
	if Global.multibind_action_just_pressed("ui_left"):
		categoryIndex -= 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	if Global.multibind_action_just_pressed("ui_right"):
		categoryIndex += 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	categoryIndex = wrap(categoryIndex, 0, activeContainers.size())
	
	currentContainer = activeContainers[categoryIndex]

func open() -> void:
	show()
	grab_focus()
	opened.emit()
	
	await get_tree().process_frame
	active = true
	
	for i in containers:
		i.active = false

func update_all_starting() -> void:
	get_tree().call_group("Options", "update_starting_values")

func close() -> void:
	active = false
	$CanvasLayer.hide()
	hide()
	closed.emit()

func update_containers() -> void:
	var lastConcurred := categoryNotShowing
	
	categoryNotShowing = activeContainers.pop_back()
	activeContainers.append(lastConcurred)

func show_limit_warning(value := 0) -> void:
	var amountOption = $PanelContainer/MarginContainer/VBoxContainer/Selector/ScrollContainer/PartnerList/PartnersAmount
	if (value == 0):
		amountOption.maximum = 7
	else:
		amountOption.maximum = INF
		
	if limitWarningShown:
		return
	
	$CanvasLayer.visible = value
	if value ==  1:
		limitWarningShown = true
		AudioManager.play_global_sfx("bump")
		canMove = false
		await $CanvasLayer.visibility_changed
		canMove = true
