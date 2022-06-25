extends Node
class_name GameManager

export (String) var levelsFolderPath

var next_level: Level

onready var current_level := $DemoLevel
onready var player := $Player
onready var fadeAnimation := $FadeOverlayLayer/AnimationPlayer

var game_ui: GameUIController

var is_player_dead:= false

func _ready():
	current_level.connect("level_changed", self, "handle_level_changed")
	game_ui = $GameUI
	
	player.connect("on_damage_taken", self, "_on_player_damage")
	player.connect("on_heal", self, "_on_player_heal")
	player.connect("on_die", self, "_on_player_died")
	
	player.position = current_level.spawn_point.position;

func _physics_process(delta):
	if is_player_dead == false: return
	
	if Input.is_action_just_pressed("reset_level"):
		current_level.get_tree().reload_current_scene()
		$GameOverCanvas.layer = -15
		is_player_dead = false

func handle_level_changed(current_level_index: int):
	var next_level_index := current_level_index + 1;
	
	next_level = load(levelsFolderPath + "Level" + str(next_level_index) + ".tscn").instance()
	next_level.z_index = -10
	add_child(next_level)
	
	fadeAnimation.play("fade_in")
	
	current_level.connect("level_changed", self, "handle_level_changed")

func _on_player_heal():
	game_ui.on_player_heal()

func _on_player_damage():
	game_ui.on_player_damage()

func _on_player_died():
	$GameOverCanvas.layer = 10
	is_player_dead = true

func _on_Fade_animation_finished(anim_name):
	if anim_name == "fade_in":
		current_level.queue_free()
		current_level = next_level
		current_level.z_index = 1
		next_level = null
		player.position = current_level.spawn_point.position;
		fadeAnimation.play("fade_out")
