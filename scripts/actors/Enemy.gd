extends Actor
class_name Enemy

var side = -1

var raycast: RayCast2D
var raycast_pivot: Position2D

func _ready():
	$Sprite/AnimationPlayer.play("default")
	raycast = $RaycastPivot/RayCast2D
	raycast_pivot = $RaycastPivot
	
	set_physics_process(false)
	_velocity.x = -speed.x
	hp = max_hp

func _physics_process(delta):
	_velocity.y += gravity * delta
	if is_on_wall() or raycast.is_colliding() == false:
		_velocity.x *= -1.0
		side *= -1
		raycast_pivot.scale.x *= -1
	
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
