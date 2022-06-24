extends Node
class_name GameManager

export (String) var levelsFolderPath

onready var current_level := $DemoLevel
onready var player := $Player
var game_ui: GameUIController

func _ready():
	current_level.connect("level_changed", self, "handle_level_changed")
	game_ui = $GameUI
	
	player.connect("on_damage_taken", self, "_on_player_damage")
	player.connect("on_heal", self, "_on_player_heal")
	
	player.position = current_level.spawn_point.position;

func handle_level_changed(current_level_index: int):
	var next_level_index := current_level_index + 1;
	
	var next_level = load(levelsFolderPath + "Level" + str(next_level_index) + ".tscn").instance()
	
	current_level.queue_free()
	current_level = next_level
	current_level.connect("level_changed", self, "handle_level_changed")
	add_child(next_level)
	
	player.position = current_level.spawn_point.position;

func _on_player_heal():
	game_ui.on_player_heal()

func _on_player_damage():
	game_ui.on_player_damage()
