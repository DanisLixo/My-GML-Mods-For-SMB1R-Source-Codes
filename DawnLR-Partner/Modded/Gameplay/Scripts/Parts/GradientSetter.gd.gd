extends Sprite2D

@onready var resourceSetter := $ResourceSetterNew
@export var targetNode: Node2D

var gradients

func _ready() -> void:
	await targetNode.ready
	apply_character_cosmic()

func apply_character_cosmic() -> void:
	var path = "res://Assets/Sprites/Players/" + get_parent().character + "/CosmicGradient.json"
	if int(Global.player_characters[get_parent().player_id]) > 3:
		path = path.replace("res://Assets/Sprites/Players", Global.config_path.path_join("custom_characters/"))
	path = ResourceSetter.get_pure_resource_path(path)
	if (FileAccess.file_exists(path)):
		var json = load(path)
		resourceSetter.resource_json = json
	else:
		path = "res://Assets/Sprites/Players/CosmicGradient.json"
		path = ResourceSetter.get_pure_resource_path(path)
		if (FileAccess.file_exists(path)):
			var json = load(path)
			resourceSetter.resource_json = json
	
	set_gradient_image()

func set_gradient_image() -> void:
	var img: Image = texture.get_image()
	
	var gradient := Gradient.new()
	gradient.remove_point(1)
	
	var rows := img.get_width()
	for i in rows:
		var color = img.get_pixel(i, 0)
		var offsert = float(i) / float(rows)
		
		if (i + 1 == rows):
			offsert = 1.0
		
		gradient.add_point(offsert, color)
		if (i == 0):
			gradient.remove_point(0)
	
	var gradImg := GradientTexture1D.new()
	gradImg.gradient = gradient
	gradImg.width = rows * 8
	
	gradients = gradImg
	
	targetNode.material.set_shader_parameter("gradient", gradImg)
