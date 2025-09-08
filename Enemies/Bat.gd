extends CharacterBody2D

## EnemeyDeathEffect場景
const EnemeyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")
## 預載入State class
var BATSTATE = preload("res://Enemies/EnemieState.gd")

## 加速度
@export var ACCELRATION = 235
## 最大速度
@export var MAX_SPEED = 50
## 摩擦力
@export var FRICTION = 180
## 距離怪物終點位置範圍
@export var WANDER_TARGET_RANGE = 3

## 角色的速度向量
var speed = Vector2.ZERO
## 狀態
var state = BATSTATE.State.IDLE

# 拿取子節點Node
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var sprite = $AnimationSprite2D
@onready var hurtBox = $HurtBox
@onready var softCollision = $SoftCollision
@onready var wanderController = $WanderController

func _ready() -> void:
	# 隨機選擇狀態
	state = pick_random_state([BATSTATE.State.IDLE,BATSTATE.State.WANDER])

func _physics_process(delta):
	# 擊退移動距離
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
	# 狀態機
	match state:
		# 閒置
		BATSTATE.State.IDLE:
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			# 每隔段時間， 隨機選擇狀態
			if wanderController.get_time_left() == 0:
				update_wander()
				
		# 徘徊
		BATSTATE.State.WANDER:
			seek_player()
			
			# 每隔段時間， 隨機選擇狀態
			if wanderController.get_time_left() == 0:
				update_wander()
			
			accelerate_towards_point(wanderController.target_position,delta)

			# 當接近怪物終點位置停下，防止前後移動
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		# 追逐	
		BATSTATE.State.CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position,delta)
			else:
				state = BATSTATE.State.IDLE

	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	
	# 更新速度
	move_and_slide()

## 根據方向移動
func accelerate_towards_point(point,delta) ->void:
	## 移動方向
	var direction = global_position.direction_to(point)
	# 移動
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELRATION * delta)
	# 根據方向，翻轉動畫
	sprite.flip_h = velocity.x < 0

## 判斷是否進入範圍，如果是則將狀態設為 CHASE。
func seek_player() -> void:
	if playerDetectionZone.can_seek_player():
		state = BATSTATE.State.CHASE

## 隨機更新狀態 、重設wander時間。
func update_wander():
	state = pick_random_state([BATSTATE.State.IDLE,BATSTATE.State.WANDER])
	wanderController.start_wander_timer(randf_range(1,3))

## 隨機返回狀態。
func pick_random_state(state_list) -> String:
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurt_box_area_entered(area) ->void:
	# 被攻擊減少生命
	stats.health -= area.damage
	# 被攻擊的移動距離
	velocity = area.knockback_vector * 120
	hurtBox.create_hit_effect()
	
func _on_stats_no_health() -> void:
	queue_free()
	
	# enemeyDeathEffect 是 Node
	var enemeyDeathEffect = EnemeyDeathEffect.instantiate()
	
	# 加入enemeyDeathEffect
	# enemeyDeathEffect 位置是Bat位置
	get_parent().add_child(enemeyDeathEffect)
	enemeyDeathEffect.global_position = global_position
