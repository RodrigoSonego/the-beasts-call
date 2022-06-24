extends Control
class_name GameUIController

var hearts_controller: HeartsController

func _ready():
	hearts_controller = $CanvasLayer/HeartsContainer

func on_player_damage():
	hearts_controller.decrease_heart()
	
func on_player_heal():
	hearts_controller.increase_heart()
