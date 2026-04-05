extends CanvasLayer

var editor: LevelEditor
var active := false
var isMouseToPet := false

func set_friendog() -> void:
	if (!active):
		active = true
		$AnimationPlayer.play("Enter")

func _ready() -> void:
	set_friendog()

func _process(delta: float) -> void:
	pass
