extends CanvasLayer

var label: Label
var textShadow: TextShadowColourChanger
var colourPalette: ColourPaletteSampler
var resourcer: ResourceSetterNew
var polygonDraw: Line2D

@onready var Toggler := get_node("/root/ModLoader/DawnLR-CharacterDebugging/CharacterDebug")
@onready var player: Player = get_parent()

var propertiesToRender: Array[String] = [
	"Cur anim: ",
	"Intended anim: "
]

func _ready() -> void:
	if (get_children().size() != 0):
		label = get_child(0)
		textShadow = label.get_child(0)
		colourPalette = textShadow.get_child(0)
		resourcer = colourPalette.get_child(0)
		polygonDraw = player.get_node("HitboxVisual")
		return
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	label = Label.new()
	textShadow = TextShadowColourChanger.new()
	colourPalette = ColourPaletteSampler.new()
	resourcer = ResourceSetterNew.new()
	polygonDraw = Line2D.new()
		
	add_child(label)
	label.uppercase = true
	label.text = "Cur Anim: NOT BEING TRACKED."
	label.process_mode = Node.PROCESS_MODE_ALWAYS
	
	textShadow.labels.append(label)
	label.add_child(textShadow)
	
	colourPalette.node_to_affect = textShadow
	colourPalette.value_to_set = "override_shadow_colour"
	textShadow.add_child(colourPalette)
	
	resourcer.node_to_affect = colourPalette
	resourcer.property_name = "texture"
	resourcer.mode = ResourceSetterNew.ResourceMode.TEXTURE
	resourcer.resource_json = Player.CHARACTER_COLOURS[Global.player_characters[0]]
	colourPalette.add_child(resourcer)
	
	polygonDraw.name = "HitboxVisual"
	polygonDraw.closed = true
	polygonDraw.width = 2
	polygonDraw.round_precision = 0
	polygonDraw.self_modulate = Color.hex(0x55ff2d80)
	add_sibling(polygonDraw)
	
	Toggler.has_toggled.connect(debug_toggled)
	visible = Toggler.enabled
	polygonDraw.visible = Toggler.enabled
	polygonDraw.process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	if (Global.level_editor_is_editing()):
		# hide()
		return
	
	update_text()
	update_hitbox_draw()

var intendedAnim := ""
func update_text() -> void:
	textShadow.handle_shadow_colours()
	
	var textArr := propertiesToRender.duplicate()
	
	intendedAnim = get_intended_animation()
	textArr[0] += player.sprite.animation
	textArr[1] += intendedAnim
	
	var text := ""
	for string in textArr:
		text += string + "\n"
	
	label.text = str(text)

func update_hitbox_draw() -> void:
	var vertices: PackedVector2Array = player.get_node("Collision").polygon
	
	polygonDraw.points = vertices

var old_power_state := ""
var new_power_state := ""
var playerOverride := ""
func get_intended_animation() -> String:
	if (playerOverride.contains("Grow") || playerOverride.contains("Shrink") || playerOverride == "PowerUp"):
		var old_state = player.get_node("PowerStates/" + old_power_state)
		var new_state = player.get_node("PowerStates/" + new_power_state)
		var hitbox_changed = new_state.power_tier != old_state.power_tier
		var shrinking = hitbox_changed and (new_state.power_tier < old_state.power_tier)
		var anim_name := ""
		if old_state.state_name != "Small" and new_power_state != "Small":
			anim_name = new_power_state + "Shrink" if shrinking else new_power_state + "Grow"
		else:
			anim_name = "Shrink" if shrinking else "Grow"
		
		if (!hitbox_changed || Settings.file.visuals.transform_style == 1):
			anim_name = "NO SPRITE!"
		
		playerOverride = "null"
		return anim_name
	
	return intendedAnim

func debug_toggled(hasEnabled: bool) -> void:
	visible = hasEnabled
	polygonDraw.visible = hasEnabled
