extends CharacterBody2D

#EnemeyDeathEffect 是 場景.tsch
#集中加載資源
const EnemeyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

#拿取節點Node
@onready var stats = $Stats

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()
 

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
