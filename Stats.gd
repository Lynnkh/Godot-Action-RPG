extends Node

#最大生命
@export var max_health:int = 1
#目前生命
@onready var health = max_health:set = set_health

signal no_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")

