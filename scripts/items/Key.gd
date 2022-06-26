extends "res://scripts/items/Item.gd"
class_name Key

export var heal_amount := 1

func _on_Key_area_entered(area):
	var player_root = area.get_node("..")
	if player_root is Player:
		apply_effect(player_root)
		queue_free()

func apply_effect(player: Player):
	player.grab_key()
	emit_signal("on_collect")
