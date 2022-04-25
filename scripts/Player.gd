extends Actor

func _physics_process(delta):
	var direction := get_input_direction()
	
	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity = move_and_slide(velocity, FLOOR_NORMAL)


func get_input_direction() -> Vector2:
	var horizontal:= Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	return Vector2(horizontal,
	-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0)


func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2) -> Vector2:
	var move_velocity:= linear_velocity
	
	move_velocity.x = direction.x * speed.x
	move_velocity.y += gravity * get_physics_process_delta_time()
	
	return move_velocity
