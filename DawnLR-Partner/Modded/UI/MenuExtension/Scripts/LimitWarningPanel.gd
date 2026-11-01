extends PanelContainer

signal closed

func _process(delta: float) -> void:
	if (visible && Global.multibind_action_just_pressed("ui_accept")):
		visible = false
		closed.emit()
