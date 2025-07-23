extends Node2D

#GrassEffect 是 場景.tsch
#集中加載資源
var GrassEffect = preload("res://Effects/grass_effect.tscn")

func create_grass_effect():
	#grassEffect 是 Node
	var grassEffect = GrassEffect.instantiate()
		
	#加入grassEffect
	#grassEffect位置是Grass位置
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position

#連接信號
func _on_hurt_box_area_entered(area):
	create_grass_effect()
	#催毀Grass Node2D
	queue_free()
