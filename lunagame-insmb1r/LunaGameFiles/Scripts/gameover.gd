extends CanvasLayer

@onready var gameover = false

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

func _ready() -> void :
	self.hide()
	get_tree().paused = false


func _process(_delta: float) -> void :
	if GlobalLuna.lives == 0 and gameover == false:
		self.show()
		gameover = true
		get_tree().paused = true
		get_node("Game Over").play()


func _on_game_over_finished() -> void :
	get_tree().quit()
