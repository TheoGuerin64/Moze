extends CanvasLayer

@onready var torch_count_label = %TorchCount

func _ready() -> void:
	var player: CharacterBody2D = get_node("/root/Main/Maze/Player")


func update_torch_count(value: int) -> void:
	torch_count_label.text = str(value)
