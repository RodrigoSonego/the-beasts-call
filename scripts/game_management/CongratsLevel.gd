extends Level
class_name CongratsLevel

onready var gear_count := $CanvasLayer/EngrenagemCount

func _process(_delta):
	if Input.is_action_just_pressed("reset_level"):
		get_tree().reload_current_scene()

func set_gear_count(count: int):
	gear_count.text = str(count)
