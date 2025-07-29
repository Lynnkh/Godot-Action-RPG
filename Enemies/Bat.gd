extends CharacterBody2D

#EnemeyDeathEffect 是 場景.tsch
#集中加載資源
const EnemeyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

@export var ACCELRATION = 250
@export var MAX_SPEED = 50
@export var FRICTION = 200

var speed = Vector2.ZERO
#預載入State class
var BATSTATE = preload("res://Enemies/EnemieState.gd")
#狀態
var state = BATSTATE.State.IDLE

#拿取節點Node
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var sprite = $AnimationSprite2D

func _physics_process(delta):
	#擊退移動距離
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
	#狀態機
	match state:
		BATSTATE.State.IDLE:
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
		BATSTATE.State.WANDER:
			pass
			
		BATSTATE.State.CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELRATION * delta)
			else:
				state = BATSTATE.State.IDLE
			#翻轉動畫
			sprite.flip_h = velocity.x < 0
	
	move_and_slide()
			
"""
判斷是否進入範圍，如果是state為CHASE，不是則不發生。
"""
func seek_player():
	if playerDetectionZone.can_seek_player():
		state = BATSTATE.State.CHASE

#連接信號
func _on_hurt_box_area_entered(area):
	#被攻擊減少生命
	stats.health -= area.damage
	#被攻擊的移動距離
	velocity = area.knockback_vector * 120
	
#連接信號
func _on_stats_no_health():
	queue_free()
	
	#enemeyDeathEffect 是 Node
	var enemeyDeathEffect = EnemeyDeathEffect.instantiate()
	
	#加入enemeyDeathEffect
	#enemeyDeathEffect 位置是Bat位置
	get_parent().add_child(enemeyDeathEffect)
	enemeyDeathEffect.global_position = global_position
