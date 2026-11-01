extends Area2D
@onready var interact: bool = false


func _ready() -> void :
	self.hide()


func _on_body_entered(body: Node2D) -> void :
	if body.is_in_group("Player") and interact == false:
		get_node("ominous").play()
		interact = true
		self.show()


func _on_ominous_finished() -> void :
	self.hide()
