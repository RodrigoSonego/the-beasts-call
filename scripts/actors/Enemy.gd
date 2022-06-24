extends Actor
class_name Enemy

var side = -1

func _ready():
	pass
	set_physics_process(false)
	_velocity.x = -speed.x
	$AnimatedSprite.scale.x = side * 1
	
	hp = max_hp
	#$RaydCast2D.position.x = $CollisionShape2D.shape.get_extents().x * side

func _physics_process(delta):
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
		side *= -1
		$AnimatedSprite.scale.x = side * 1
		#$RayCast2D.position.x = $CollisionShape2D.shape.get_extents().x * side
	
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

#not $RayCast2D.is_colliding() and is_on_floor()

func take_damage():
	hp -= 1
	
	$Hurtbox/CollisionShape2D.disabled = true
	if( hp <= 0 ):
		die()

func take_knockback(knockback_force: float):
	_velocity.x = knockback_force
	$KnockbackTimer.start()

func die():
	queue_free()

func reset_velocity():
	_velocity.x = speed.x * side

func _on_KnockbackTimer_timeout():
	reset_velocity()
	$Hurtbox/CollisionShape2D.disabled = false
