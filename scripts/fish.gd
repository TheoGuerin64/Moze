extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	Events.change_scene.emit("res://scenes/scene_manager.tscn")
