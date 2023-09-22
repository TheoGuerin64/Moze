extends Node


func _ready():
	Events.change_scene.connect(_change_scene)


func _change_scene(path_to_scene):
	for child in get_children():
		remove_child(child)
		child.queue_free()

	var new_scene = load(path_to_scene).instantiate()
	add_child(new_scene)
