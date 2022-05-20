extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL:= Vector2.UP     # Vetor perpendicular ao chão

export var max_hp := 3
export var hp: int

export var gravity:= 3000.0
export var speed := Vector2(300.0, 1000.0)

var _velocity:= Vector2.ZERO
