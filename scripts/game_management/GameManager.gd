extends Node
class_name GameManager

export (String) var levelsFolderPath
var next_level = null

var final_level = preload("res://scenes/levels/CongratsLevel.tscn")
var current_level_resource = preload("res://scenes/levels/Level1.tscn")
onready var current_level_instance := $Level1
onready var player := $Player
onready var fadeAnimation := $FadeOverlayLayer/AnimationPlayer

var game_ui: GameUIController

var is_player_dead:= false

var gear_count := 0

func _ready():
	current_level_instance.connect("level_changed", self, "handle_level_changed")
	game_ui = $GameUI
	
	player.connect("on_damage_taken", self, "_on_player_damage")
	player.connect("on_heal", self, "_on_player_heal")
	player.connect("on_die", self, "_on_player_died")
	player.connect("on_collect_gear", self, "_on_collect_gear")
	player.connect("on_collect_key", self, "_on_collect_key")
	
	player.position = current_level_instance.spawn_point.position

func _physics_process(delta):
	if is_player_dead == false: return
	
	if Input.is_action_just_pressed("reset_level"):
		reset_level()


func reset_level():
	gear_count -= current_level_instance.gears_collected
	game_ui.update_gear_count(gear_count)
	game_ui.update_key_count(0)
	
	load_level(current_level_resource)
	$GameOverCanvas.layer = -15
	
	player.respawn()
	player.position = current_level_instance.spawn_point.position
	game_ui.on_player_fully_heal()
	is_player_dead = false
	
	

func handle_level_changed(current_level_index: int):
	var next_level_index := current_level_index + 1;
	if current_level_index == 3:
		next_level = final_level
	else:
		next_level = load(levelsFolderPath + "Level" + str(next_level_index) + ".tscn")
	
	gear_count += current_level_instance.gears_collected
	
	game_ui.update_key_count(0)
	fadeAnimation.play("fade_in")
	get_tree().paused = true

func load_level(level: Resource):
	current_level_resource = level
	
	current_level_instance.queue_free()
	
	current_level_instance = current_level_resource.instance()
	add_child(current_level_instance)
	
	current_level_instance.connect("level_changed", self, "handle_level_changed")
	
	if current_level_instance is CongratsLevel:
		current_level_instance.set_gear_count(gear_count)
		game_ui.queue_free()

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
		load_level(next_level)
		current_level_instance.z_index = 1
		next_level = null
		
		player.position = current_level_instance.spawn_point.position
		move_child(player, get_child_count()-1)
		
		get_tree().paused = false
		fadeAnimation.play("fade_out")
		
