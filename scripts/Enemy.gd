extends KinematicBody2D

var speed = Vector2(300.0,1000.0)
var side = -1
var gravity= 4000.0
var velocity = Vector2.ZERO

func _ready():
	pass
	set_physics_process(false)
	velocity.x = -speed.x
	$AnimatedSprite.scale.x = side * 1
	
	#$RaydCast2D.position.x = $CollisionShape2D.shape.get_extents().x * side

func _physics_process(delta):
	velocity.y += gravity * delta
	if is_on_wall():
		velocity.x *= -1.0
		side *= -1
		$AnimatedSprite.scale.x = side * 1
		#$RayCast2D.position.x = $CollisionShape2D.shape.get_extents().x * side
	
	velocity.y = move_and_slide(velocity, Vector2.UP).y

#not $RayCast2D.is_colliding() and is_on_floor()

func take_damage():
	print('ai caraio')
	self.queue_free()
