extends CharacterBody2D

@export var speed: float = 300

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
