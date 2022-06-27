extends Node2D

var game_scene = preload("res://scenes/levels/GameManager.tscn")

func _on_BotaoJogar_pressed():
	var root = get_tree().get_root()
	for child in root.get_children():
		child.queue_free()
	
	root.add_child(game_scene.instance())


func _on_BotaoSair_pressed():
	get_tree().quit()


func _on_BotaoJogar_mouse_entered():
	$BotaoJogar.modulate.r = 0.75
	$BotaoJogar.modulate.g = 0.75
	$BotaoJogar.modulate.b = 0.75


func _on_BotaoSair_mouse_entered():
	$BotaoSair.modulate.r = 0.75
	$BotaoSair.modulate.g = 0.75
	$BotaoSair.modulate.b = 0.75


func _on_BotaoJogar_mouse_exited():
	$BotaoJogar.modulate.r = 1
	$BotaoJogar.modulate.g = 1
	$BotaoJogar.modulate.b = 1


func _on_BotaoSair_mouse_exited():
	$BotaoSair.modulate.r = 1
	$BotaoSair.modulate.g = 1
	$BotaoSair.modulate.b = 1
