extends Area2D

signal on_door_interaction()

var is_player_in_range:= false

func _physics_process(delta):
	if(is_player_in_range == false): return
	
	if(Input.is_action_just_pressed("interact_with_door")):
		emit_signal("on_door_interaction")


func _on_Door_area_entered(area):
	print('entrou aqui')
	is_player_in_range = true


func _on_Door_area_exited(area):
	print('saiu')
	is_player_in_range = false
	
