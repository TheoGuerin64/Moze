extends CanvasLayer

@onready var torch_count_label = %TorchCount


func update_torch_count(value: int) -> void:
	torch_count_label.text = str(value)
