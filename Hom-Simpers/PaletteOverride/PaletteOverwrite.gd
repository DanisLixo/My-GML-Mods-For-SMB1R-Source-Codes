extends CanvasLayer

@onready var shader: ShaderMaterial = $Overrider.material as ShaderMaterial
var nearest_range := 0.01

func _ready() -> void:
	apply_new_palette()
	Global.level_theme_changed.connect(apply_new_palette)

func apply_new_palette() -> void:
	shader.set_shader_parameter("closest", nearest_range)
	
	shader.set_shader_parameter("game_palette", %GamePalette.texture)
	shader.set_shader_parameter("override_palette", %OverridePalette.texture)
	
	shader.set_shader_parameter("palette_size", %GamePalette.texture.get_size().x)
	shader.set_shader_parameter("override_palette_size", %OverridePalette.texture.get_size().x)
