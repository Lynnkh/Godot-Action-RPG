extends Node

#最大生命
@export var max_health:int = 1 :set = set_max_health
#目前生命
@onready var health: int = max_health :set = set_health

signal no_health
signal health_change(value)
signal max_health_changed(value)


func set_max_health(value):
	max_health = value
	#生命永遠小魚最大生命
	self.health = min(health,max_health)
	emit_signal("max_health_changed",max_health)

func set_health(value):
	health = value
	emit_signal("health_change",health)
	if health <= 0:
		emit_signal("no_health")
