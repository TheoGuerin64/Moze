extends Sprite2D


func _process(_delta: float) -> void:
	var camera: Camera2D = get_node("../Camera")
	material.set_shader_parameter("camera_pos", camera.global_position / 1000)
