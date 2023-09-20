extends CharacterBody2D


const SPEED = 300.0


func _physics_process(_delta):
	velocity.x = 0
	if Input.is_action_pressed("game_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("game_right"):
		velocity.x = SPEED

	velocity.y = 0
	if Input.is_action_pressed("game_up"):
		velocity.y = -SPEED
	elif Input.is_action_pressed("game_down"):
		velocity.y = SPEED

	move_and_slide()
