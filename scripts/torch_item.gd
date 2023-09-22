extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	Data.torch_count += 1
	queue_free()
