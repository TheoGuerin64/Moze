extends Area2D


func _on_body_entered(body: Node2D) -> void:
	var ui: CanvasLayer = get_node("/root/Main/UI")

	body.torch_count += 1
	ui.update_torch_count(body.torch_count)
	queue_free()
