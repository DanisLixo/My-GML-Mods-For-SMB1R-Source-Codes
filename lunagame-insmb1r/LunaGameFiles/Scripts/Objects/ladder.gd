extends Area2D

@onready var onladder = false


func _ready() -> void :
    pass



func _process(delta: float) -> void :
    pass


func _on_body_entered(body: Node2D) -> void :
    if body.is_in_group("Player") and !onladder:
        onladder = true



func _on_body_exited(_body: Node2D) -> void :
    if onladder:
        onladder = false
