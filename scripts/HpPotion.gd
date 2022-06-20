extends "res://scripts/Item.gd"

export var heal_amount := 1

func _on_Key_area_entered(area):
	var player_root = area.get_node("..")
	if player_root is Player:
		apply_effect(player_root)
		queue_free()

func apply_effect(player: Player):
	player.heal(heal_amount)

