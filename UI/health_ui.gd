extends Control

##生命愛心變量
var hearts:int = 4:set = set_hearts
##最大生命愛心變量
var max_heart:int = 4:set = set_max_heart

@onready var label = $Label

func set_hearts(value):
	hearts = clamp(value, 0, max_heart)
	#設置label的顯示
	if label != null:
		label.text = "HP = " + str(hearts)
	
func set_max_heart(value):
	max_heart = max(value, 1)

func _ready() -> void:
	#設置屬性
	self.max_heart = PlayStats.max_health
	self.hearts = PlayStats.health
	#呼叫信號
	PlayStats.health_change.connect(self.set_hearts)
