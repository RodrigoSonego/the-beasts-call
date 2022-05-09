extends Actor

var anim_state_machine: AnimationNodeStateMachinePlayback

var current_state:= "idle" # TODO: se pa achar uma maneira melhor do que só string

func _ready():
	anim_state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(_delta):
	current_state = anim_state_machine.get_current_node()
	
	var is_jump_released:= Input.is_action_just_released("jump") and velocity.y < 0
	
	var direction := get_input_direction()
	
	velocity = calculate_move_velocity(velocity, direction, speed, is_jump_released)
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
	handle_animation(velocity)
	handle_attack_input()


func get_input_direction() -> Vector2:
	var horizontal:= Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	return Vector2(horizontal,
	-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0)


func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2, 
															is_jump_released: bool) -> Vector2:
	
	if(current_state == "attack" and is_on_floor()):
		return Vector2.ZERO
	
	var move_velocity:= linear_velocity
	
	move_velocity.x = direction.x * speed.x
	move_velocity.y += gravity * get_physics_process_delta_time()
	
	if direction.y == -1.0:
		move_velocity.y = speed.y * direction.y
		
	if is_jump_released:
		move_velocity.y = 0.0
	
	return move_velocity

func handle_animation(current_velocity: Vector2) -> void:
	if current_velocity == Vector2.ZERO:
		anim_state_machine.travel("idle")
		return
	
	if current_velocity.y < 0:
		anim_state_machine.travel("jump")
		return
	
	if current_velocity.x != 0:
		anim_state_machine.travel("walk")
		
		if current_velocity.x > 0:
			get_node("SpritePivot").scale.x = 1
		if current_velocity.x < 0:
			get_node("SpritePivot").scale.x = -1
	
	
	
func handle_attack_input():
	if Input.is_action_just_pressed("attack") == false:
		return
	
	if current_state == "jump":
		anim_state_machine.travel("jump_attack")
		return
	
	anim_state_machine.travel("attack")


func _on_AttackHitbox_area_entered(area):
	if(area.is_in_group("enemy")):
		var enemy = area.get_node('..')
		
		enemy.take_damage()


func _on_AttackHitbox_body_entered(body):
	#print(body.name)
	pass
