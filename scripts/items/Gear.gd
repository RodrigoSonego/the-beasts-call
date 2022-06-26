extends "res://scripts/items/Item.gd"
class_name Gear

func _on_Gear_area_entered(area):
	var player_root = area.get_node("..")
	if player_root is Player:
		apply_effect(player_root)
		queue_free()

func apply_effect(player: Player):
	player.grab_gear()
	emit_signal("on_collect")
