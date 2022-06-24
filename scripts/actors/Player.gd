extends Actor
class_name Player

var anim_state_machine: AnimationNodeStateMachinePlayback
var current_state:= "idle" # TODO: se pa achar uma maneira melhor do que só string

export var attack_knockback := 500.0

var has_key := false

signal on_damage_taken()
signal on_heal()
signal on_collect_key()
signal on_collect_gear()
signal on_die()

func _ready():
	anim_state_machine = $AnimationTree.get("parameters/playback")
	

func _physics_process(_delta):
	$HpLabel.text = "HP: " + str(hp)
	
	current_state = anim_state_machine.get_current_node()
	
	var is_jump_released:= Input.is_action_just_released("jump") and _velocity.y < 0
	
	var direction := get_input_direction()
	
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_released)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
	handle_animation(_velocity)
	handle_attack_input()


func get_input_direction() -> Vector2:
	var horizontal:= Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	return Vector2(horizontal,
	-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0)


func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2, 
															is_jump_released: bool) -> Vector2:
	
	if (current_state == "attack" and is_on_floor()) or current_state == "die":
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
	if current_state == "take_damage" or current_state == "die":
		return
	
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
	if current_state == "die" or current_state == "take_damage":
		return
	
	if Input.is_action_just_pressed("attack") == false:
		return
	
	if current_state == "jump":
		anim_state_machine.travel("jump_attack")
		return
	
	anim_state_machine.travel("attack")

func take_damage():
	hp -= 1
	emit_signal("on_damage_taken")
	if hp <= 0:
		die()
		return

	anim_state_machine.travel("take_damage")

func die():
	anim_state_machine.travel("die")
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$PlayerFeet.set_deferred("disabled", true)
	
func heal(amount: int):
	if hp == max_hp:
		return
	
	emit_signal("on_heal")
	if hp + amount > max_hp:
		hp = max_hp
		return

	hp += amount
	
	print(hp)

func grab_key():
	has_key = true

func consume_key():
	has_key = false

func get_has_key():
	return has_key

func _on_AttackHitbox_area_entered(area):
	if(area.is_in_group("enemy")):
		var enemy = area.get_node('..')
		
		enemy.take_damage()
		enemy.take_knockback(attack_knockback * get_node("SpritePivot").scale.x)

func _on_Hurtbox_area_entered(area):
	take_damage()

