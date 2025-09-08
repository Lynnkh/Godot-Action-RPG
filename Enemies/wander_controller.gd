extends Node2D

## 怪物終點位置範圍
@export var wander_range: int = 32
## 怪物初始位置
@onready var start_position: Vector2 = global_position
## 怪物終點位置
@onready var target_position: Vector2 = global_position

## 拿取子節點Node-Timer
@onready var timer = $Timer

func _ready() -> void:
	# 開始時移動
	update_target_position()

## 更新怪物終點位置
func update_target_position() -> void:
	var target_vector = Vector2(randf_range(-wander_range,wander_range),randf_range(-wander_range,wander_range))
	## target_position永遠相對於start_position
	target_position = start_position + target_vector

## 獲取剩餘時間
func get_time_left() ->float:
	return timer.time_left

## 設置徘徊時間
func start_wander_timer(duration):
	timer.start(duration)

## 一段時間後，更新怪物終點位置
func _on_timer_timeout() -> void:
	update_target_position()
