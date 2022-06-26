extends Node
class_name GameManager

export (String) var levelsFolderPath
var next_level = null

onready var current_level := $DemoLevel
onready var player := $Player
onready var fadeAnimation := $FadeOverlayLayer/AnimationPlayer

var game_ui: GameUIController

var is_player_dead:= false

var gear_count := 0

func _ready():
	current_level.connect("level_changed", self, "handle_level_changed")
	game_ui = $GameUI
	
	player.connect("on_damage_taken", self, "_on_player_damage")
	player.connect("on_heal", self, "_on_player_heal")
	player.connect("on_die", self, "_on_player_died")
	player.connect("on_collect_gear", self, "_on_collect_gear")
	player.connect("on_collect_key", self, "_on_collect_key")
	
	player.position = current_level.spawn_point.position;

func _physics_process(delta):
	if is_player_dead == false: return
	
	if Input.is_action_just_pressed("reset_level"):
		current_level.get_tree().reload_current_scene()
		$GameOverCanvas.layer = -15
		is_player_dead = false

func handle_level_changed(current_level_index: int):
	var next_level_index := current_level_index + 1;
	next_level = load(levelsFolderPath + "Level" + str(next_level_index) + ".tscn")
	
	game_ui.update_key_count(0)
	fadeAnimation.play("fade_in")
	get_tree().paused = true

func _on_player_heal():
	game_ui.on_player_heal()

func _on_player_damage():
	game_ui.on_player_damage()

func _on_player_died():
	$GameOverCanvas.layer = 10
	is_player_dead = true

func _on_collect_gear():
	gear_count += 1
	game_ui.update_gear_count(gear_count)

func _on_collect_key():
	game_ui.update_key_count(1)

func _on_Fade_animation_finished(anim_name):
	if anim_name == "fade_in":
		current_level.queue_free()
		
		var next_level_instance = next_level.instance()
		add_child(next_level_instance)
		current_level = next_level_instance
		current_level.z_index = 1
		
		next_level = null
		current_level.connect("level_changed", self, "handle_level_changed")
		player.position = current_level.spawn_point.position;
		
		get_tree().paused = false
		
		fadeAnimation.play("fade_out")
		
