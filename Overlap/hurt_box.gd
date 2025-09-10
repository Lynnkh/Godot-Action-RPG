extends Area2D

const HitEffect = preload("res://Effects/hit_effect.tscn")

@onready var timer = $Timer
@onready var collisionShape = $CollisionShape2D

##無敵變量
var invincible:bool = false:set = set_invincible

signal invincibility_started
signal invincibility_ended

##set函數
func set_invincible(value):
	invincible = value
	if invincible ==true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func create_hit_effect():
	var effect= HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

## 設置無敵狀態
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

## 時間到呼叫set函數 set_invincible
func _on_timer_timeout() -> void:
	self.invincible = false

## 被攻擊禁用碰撞形狀
func _on_invincibility_started() -> void:
	collisionShape.set_deferred("disabled",true)

## 無敵結束啟用碰撞形狀
func _on_invincibility_ended() -> void:
	collisionShape.disabled = false
