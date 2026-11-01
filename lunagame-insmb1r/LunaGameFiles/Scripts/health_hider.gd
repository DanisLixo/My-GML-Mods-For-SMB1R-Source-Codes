extends ColorRect

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

func _ready() -> void :
	self.hide()



func _process(_float) -> void :
	if GlobalLuna.health >= 1:
		self.hide()

	elif GlobalLuna.health <= 1:
		self.show()
