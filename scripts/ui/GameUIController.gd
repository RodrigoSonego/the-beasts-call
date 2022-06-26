extends Control
class_name GameUIController

var hearts_controller: HeartsController
var gear_counter: ScoreCounter
var key_counter: ScoreCounter

func _ready():
	hearts_controller = $CanvasLayer/HeartsContainer
	gear_counter = $CanvasLayer/VBoxContainer/GearContainer
	key_counter = $CanvasLayer/VBoxContainer/KeyContainer

func on_player_damage():
	hearts_controller.decrease_heart()
	
func on_player_heal():
	hearts_controller.increase_heart()

func update_gear_count(count: int):
	gear_counter.update_count(count)

func update_key_count(count: int):
	key_counter.update_count(count)
