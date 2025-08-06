extends Control

##生命愛心變量
var hearts:int = 4:set = set_hearts
##最大生命愛心變量
var max_heart:int = 4:set = set_max_heart

#獲取子節點
@onready var healthUIFull = $HealthUIFull
@onready var healthUIEmpty = $HealthUIEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_heart)
	if healthUIFull != null:
		healthUIFull.size.x = hearts * 15
	
func set_max_heart(value):
	max_heart = max(value, 1)
	self.hearts = min(hearts, max_heart)
	if healthUIEmpty != null:
		healthUIEmpty.size.x = max_heart * 15
		
func _ready() -> void:
	#設置屬性
	self.max_heart = PlayStats.max_health
	self.hearts = PlayStats.health
	#連接信號
	#設置愛心UI
	PlayStats.health_change.connect(self.set_hearts)
	PlayStats.max_health_changed.connect(self.set_max_heart)
