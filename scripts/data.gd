extends Node

var ui: CanvasLayer


var torch_count: int = 0:
	set(value):
		torch_count = value
		ui.update_torch_count(value)

