extends Area2D

signal on_door_interaction()
export var is_locked:= false

var is_player_in_range:= false
var player_has_key := false

func _physics_process(delta):
	if(is_player_in_range == false): return
	
	if(Input.is_action_just_pressed("interact_with_door")):
		if (is_locked and player_has_key == false):
			print('ta trancada manito')
			return

		emit_signal("on_door_interaction")

func _on_Door_area_entered(area):
	is_player_in_range = true
	
	var player: Player
	player = area.get_node("..")
	
	player_has_key = player.get_has_key()

func _on_Door_area_exited(area):
	is_player_in_range = false
