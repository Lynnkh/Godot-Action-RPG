extends CharacterBody2D

## PlayerHurtSound場景
const PlayerHurtSound = preload("res://Player/player_hurt_sound.tscn")

## 最大速度
@export var MAX_SPEED = 150
## 加速度
@export var ACCELERATION = 500
## 翻滾速度
@export var ROLL_SPEED = 125
## 摩擦力
@export var FRICTION = 500

#狀態機常數
enum {
	MOVE,
	ROLL,
	ATTACK
}

# 狀態機變數
var state = MOVE
var roll_vector = Vector2.DOWN
## PlayStats全局變數是"res://Player/play_stats.tscn"
var stats = PlayStats

# 拿取節點Node
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get('parameters/playback')
@onready var swordHitBox = $HitBoxPivot/SwordHitBox
@onready var hurtBox = $HurtBox
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	# 改變隨機種子，每次遊戲都會不一樣
	randomize()
	stats.no_health.connect(func(): queue_free())
	swordHitBox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	

## 移動狀態
func move_state(delta) -> void:
	
	# 往上是負，往下是正。往右是正，往左是負。
	# 如果按下對應按鈕，get_action_strength回傳 1
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# 因為勾股定理，斜者跑比較快，所以使用normalized()向量化輸入
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitBox.knockback_vector = input_vector
		# 只有在移動時更新混合位置，停下移動將會是原來的值
		animationTree.set('parameters/Idle/blend_position',input_vector)
		animationTree.set('parameters/Run/blend_position',input_vector)
		animationTree.set('parameters/Attack/blend_position',input_vector)
		animationTree.set('parameters/Roll/blend_position',input_vector)
		animationState.travel('Run')
		velocity = velocity.move_toward(input_vector * MAX_SPEED,ACCELERATION * delta)
	else:
		animationState.travel('Idle')
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()
	
	# 按下翻滾鍵
	# 改變狀態:從MOVE變成ROLL
	if Input.is_action_just_pressed("roll") :
		state = ROLL
	
	# 按下攻擊鍵
	# 改變狀態:從MOVE變成ATTACK
	if Input.is_action_just_pressed("attack") :
		state = ATTACK
		

## 翻滾狀態
func roll_state(delta) -> void:
	velocity = roll_vector * ROLL_SPEED
	animationState.travel('Roll')
	move()
	
## 攻擊狀態
func attack_state(delta) -> void:
	velocity = Vector2.ZERO
	animationState.travel('Attack')

## 移動函式
func move() -> void:
	# move_and_slide() 是「連續」移動的函式每幀都要呼叫它，否則角色會停止
	move_and_slide()

## 動畫軌:翻軌呼叫方法
func roll_animation_finished() -> void:
	velocity = Vector2.ZERO
	state = MOVE

## 動畫軌:攻擊呼叫方法
func attack_animation_finished() -> void:
	state = MOVE

func _on_hurt_box_area_entered(area: Area2D) -> void:
	stats.health = stats.health + area.damage
	hurtBox.start_invincibility(0.6)
	hurtBox.create_hit_effect()
		
	## 獲取PlayerHurtSound節點
	var playerHurtSound = PlayerHurtSound.instantiate()
	# 添加節點
	get_tree().current_scene.add_child(playerHurtSound)

## 當HurtBox進入無敵
func _on_hurt_box_invincibility_started() -> void:
	blinkAnimationPlayer.play("Start")

## 當HurtBox結束無敵
func _on_hurt_box_invincibility_ended() -> void:
	blinkAnimationPlayer.play("Stop")
