extends Node

@export var amount_node: HBoxContainer

@onready var saved_maximum: float = amount_node.maximum
@onready var saved_value: float = amount_node.selected_index

func _ready() -> void:
	limit_toggled(Settings.file.partners.unlock_limit)

func limit_toggled(new_value: Variant) -> void:
	if (new_value):
		amount_node.maximum = INF
	else:
		amount_node.maximum = saved_maximum
		amount_node.selected_index = saved_maximum
