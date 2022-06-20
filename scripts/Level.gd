extends Node

signal level_changed(level_index)

export var level_index := 0

func _onChangeLevel(_area):
	print('chegou aqui')
	emit_signal("level_changed", level_index)
