extends Node

#最大生命
@export var max_health:int = 1
#目前生命
@onready var health = max_health:set = set_health

signal no_health
signal health_change(value)

func set_health(value):
	health = value
	emit_signal("health_change",health)
	if health <= 0:
		emit_signal("no_health")
