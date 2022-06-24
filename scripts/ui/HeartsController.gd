extends HBoxContainer
class_name HeartsController

export (Texture) var fullHeartSprite
export (Texture) var emptyHeartSprite

var hearts: Array
var lastActiveHeartIndex: int

func _ready():
	hearts = get_children()
	lastActiveHeartIndex = hearts.size() - 1


func decrease_heart():
	if lastActiveHeartIndex < 0: return
	
	hearts[lastActiveHeartIndex].texture = emptyHeartSprite
	
	lastActiveHeartIndex -= 1

func increase_heart():
	if lastActiveHeartIndex == hearts.size()-1: return
	
	hearts[lastActiveHeartIndex+1].texture = fullHeartSprite
	lastActiveHeartIndex += 1
