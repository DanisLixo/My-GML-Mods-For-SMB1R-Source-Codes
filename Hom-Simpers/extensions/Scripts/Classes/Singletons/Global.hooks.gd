extends Object

const PALETTE_OVERWRITE = preload("res://mods-unpacked/Hom-Simpers/PaletteOverride/PaletteOverwrite.tscn")

func _ready(c: ModLoaderHookChain) -> void:
	c.execute_next()
	Global.add_child(PALETTE_OVERWRITE.instantiate())
