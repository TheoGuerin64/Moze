extends Node

@onready var ui: CanvasLayer = get_node("/root/SceneManager/Main/UI")


var torch_count: int = 0:
	set(value):
		torch_count = value
		ui.update_torch_count(value)
