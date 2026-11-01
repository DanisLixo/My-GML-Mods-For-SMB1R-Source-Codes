extends CanvasLayer

@onready var ispaused = false
@onready var display = true

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

func _ready() -> void :
	self.hide()
	get_tree().paused = false



func _process(_delta: float) -> void :
	if GlobalLuna.lives == 0:
		queue_free()

	if Global.multibind_action_just_pressed("pause") and ispaused == false:
			ispaused = true
			display = true
			self.show()
			get_tree().paused = true
			get_node("Paused").play()


	elif Global.multibind_action_just_pressed("pause") and ispaused == true:
			ispaused = false
			display = false
			self.hide()
			get_tree().paused = false
			get_node("Paused").play()

	if Global.player_action_just_pressed("action", 0) and ispaused == true and display == true:
		self.hide()
		display = false
	elif Global.player_action_just_pressed("action", 0) and ispaused == true and display == false:
		self.show()
		display = true
