extends CanvasLayer

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

@onready var money_label: Label = %Money
@onready var score_label: Label = %Score
@onready var lives_label: Label = %Lives
@onready var area_label: Label = %Area
@onready var time_label: Label = %Time
@onready var timewarning = get_node("HURRYUP")
@onready var hurry: bool = false
@onready var timeout: bool = false

@onready var lives_containers := [%CContainer, %CContainer2, %CContainer3, %CContainer4]

func _ready() -> void :
	lives_containers[0].show()
	timewarning.play("Invisible")


func _process(_delta: float) -> void :

	if GlobalLuna.money < 10:
		money_label.text = "*0" + str(GlobalLuna.money)
	elif GlobalLuna.money >= 10:
		money_label.text = "*" + str(GlobalLuna.money)


	if GlobalLuna.score < 10:
		score_label.text = "000000" + str(GlobalLuna.score)
	if GlobalLuna.score >= 10:
		score_label.text = "00000" + str(GlobalLuna.score)
	if GlobalLuna.score >= 100:
		score_label.text = "0000" + str(GlobalLuna.score)
	if GlobalLuna.score >= 1000:
		score_label.text = "000" + str(GlobalLuna.score)
	if GlobalLuna.score >= 10000:
		score_label.text = "00" + str(GlobalLuna.score)
	if GlobalLuna.score >= 100000:
		score_label.text = "0" + str(GlobalLuna.score)
	if GlobalLuna.score >= 1000000:
		score_label.text = "" + str(GlobalLuna.score)



	if GlobalLuna.lives < 10:
		lives_label.text = "LUNA*0" + str(GlobalLuna.lives)
	elif GlobalLuna.lives >= 10:
		lives_label.text = "LUNA*!!" + str(GlobalLuna.lives)


	area_label.text = "AREA*" + str(GlobalLuna.level)


	if GlobalLuna.time >= 100:
		time_label.text = "TIME*" + str(GlobalLuna.time)
	if GlobalLuna.time < 100:
		time_label.text = "TIME*0" + str(GlobalLuna.time)
	if GlobalLuna.time < 10:
		time_label.text = "TIME*00" + str(GlobalLuna.time)
	if GlobalLuna.time < 1:
		time_label.text = "TIME*000"


	if GlobalLuna.health == 4:
		lives_containers[3].show()
		lives_containers[2].show()
		lives_containers[1].show()
		lives_containers[0].show()
	if GlobalLuna.health == 3:
		lives_containers[3].hide()
		lives_containers[2].show()
		lives_containers[1].show()
		lives_containers[0].show()
	if GlobalLuna.health == 2:
		lives_containers[2].hide()
		lives_containers[1].show()
		lives_containers[0].show()
	if GlobalLuna.health == 1:
		lives_containers[1].hide()
		lives_containers[0].show()

	if GlobalLuna.health == 0:
		lives_containers[0].hide()


	if GlobalLuna.time <= 100 and hurry == false:
		hurry = true

		timewarning.play("TimeWarning")
		get_node("WARNING").play()

	if GlobalLuna.time == 0 and GlobalLuna.playerdead and hurry == true and timeout == false:
		timeout = true
		timewarning.play("TimeUp")
		get_node("TIMEOUT").play()

func _on_warning_finished() -> void :
		timewarning.play("Invisible")
