extends HBoxContainer
class_name ScoreCounter

onready var score_label := $ScoreLabel

func update_count(score: int) -> void:
	score_label.text = "x" + str(score)
