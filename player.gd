extends CharacterBody2D


const SPEED = 300.0


func _physics_process(_delta):
	var xDirection = Input.get_axis("game_left", "game_right")
	if xDirection:
		velocity.x = xDirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var yDirection = Input.get_axis("game_up", "game_down")
	if yDirection:
		velocity.y = yDirection * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
