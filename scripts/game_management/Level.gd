extends Node
class_name Level

signal level_changed(level_index)

export var level_index := 0
onready var spawn_point := $SpawnPoint

export var gears_collected:= 0
var collected_key:= false

func _ready():
	for node in get_children():
		if node is Gear:
			node.connect("on_collect", self, "_on_grab_gear")
		
		if node is Key:
			node.connect("on_collect", self, "_on_grab_key")
		
		if node is Door:
			node.connect("on_door_interaction", self, "_on_change_level")

func _on_change_level():
	emit_signal("level_changed", level_index)

func _on_grab_key():
	collected_key = true

func _on_grab_gear():
	gears_collected += 1
