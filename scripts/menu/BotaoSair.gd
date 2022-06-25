extends Button

func _on_Jogar_mouse_entered():
	$Sprite.modulate.r = 0.65
	$Sprite.modulate.g = 0.65
	$Sprite.modulate.b = 0.65
	pass # Replace with function body.


func _on_Jogar_mouse_exited():
	$Sprite.modulate.r = 1
	$Sprite.modulate.g = 1
	$Sprite.modulate.b = 1
	pass # Replace with function body.


func _on_Jogar_pressed():
	$Sprite.modulate.r = 0.5
	$Sprite.modulate.g = 0.5
	$Sprite.modulate.b = 0.5
	get_tree().quit()
	pass # Replace with function body.
