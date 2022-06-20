extends Node

export (String) var levelsFolderPath

onready var current_level = $DemoLevel

func _ready():
	current_level.connect("level_changed", self, "handle_level_changed")

func handle_level_changed(current_level_index: int):
	var next_level_index := current_level_index + 1;
	
	var next_level = load(levelsFolderPath + "Level" + str(next_level_index) + ".tscn").instance()
	
	current_level.queue_free()
	current_level = next_level
	current_level.connect("level_changed", self, "handle_level_changed")
	add_child(next_level)
