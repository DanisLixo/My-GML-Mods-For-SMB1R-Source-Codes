extends Panel

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

func _ready() -> void :
		self.show()




func _process(_delta: float) -> void :

		if GlobalLuna.health == 4:
			get_node("CContainer4").show()
			if GlobalLuna.health > 4:
				get_node("CContainer4").hide()
				if GlobalLuna.health > 3:
					get_node("CContainer3").hide()
					if GlobalLuna.health > 2:
						get_node("CContainer2").hide()
						if GlobalLuna.health > 1:
							get_node("CContainer").hide()
