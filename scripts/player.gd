extends CharacterBody2D

@export var speed: float = 300
@export var torch_count: int = 0

var maze: TileMap

var is_moving: bool = false
var target_direction: Vector2i = Vector2i.ZERO
var target_pos: Vector2 = Vector2.ZERO


func _ready() -> void:
	maze = get_parent()


func get_direction(coord: Vector2i) -> Vector2i:
	var direction: Vector2i = Vector2i.ZERO

	if Input.is_action_pressed("game_left") and not maze.is_wall(coord + Vector2i.LEFT):
		direction.x = -1
	elif Input.is_action_pressed("game_right") and not maze.is_wall(coord + Vector2i.RIGHT):
		direction.x = 1
	elif Input.is_action_pressed("game_up") and not maze.is_wall(coord + Vector2i.UP):
		direction.y = -1
	elif Input.is_action_pressed("game_down") and not maze.is_wall(coord + Vector2i.DOWN):
		direction.y = 1

	return direction


func _physics_process(delta) -> void:
	if not is_moving:
		var map_position: Vector2i = maze.local_to_map(position)
		var direction: Vector2i = get_direction(map_position)

		if direction != Vector2i.ZERO:
			target_pos = maze.map_to_local(map_position + direction)
			target_direction = direction
			is_moving = true
	else:
		velocity = speed * target_direction * delta

		var distance_to_target = position.distance_to(target_pos)
		var move_distance = velocity.length()

		if distance_to_target < move_distance:
			velocity = target_direction * distance_to_target
			is_moving = false

		move_and_collide(velocity)


func is_torch(torches: Node2D) -> bool:
	for torch in torches.get_children():
		if torch.position == position:
			return true
	return false


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var input_event: InputEventKey = event as InputEventKey
		if input_event.is_action_pressed("game_restart"):
			Events.change_scene.emit("res://scenes/scene_manager.tscn")
		if input_event.is_action_pressed("game_quit"):
			get_tree().quit()


func _process(_delta: float) -> void:
	if not is_moving and Input.is_action_just_released("game_use"):
		var torches: Node2D = maze.get_node("Torches")
		if torch_count <= 0 or is_torch(torches):
			return

		var ui: CanvasLayer = get_node("/root/Main/UI")

		var torch: PointLight2D = preload("res://scenes/torch.tscn").instantiate()
		torch.position = position
		maze.get_node("Torches").add_child(torch)

		torch_count -= 1
		ui.update_torch_count(torch_count)
