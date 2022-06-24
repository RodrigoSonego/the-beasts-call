extends Node
class_name Level

signal level_changed(level_index)

export var level_index := 0
onready var spawn_point := $SpawnPoint

func _on_change_level():
	emit_signal("level_changed", level_index)
