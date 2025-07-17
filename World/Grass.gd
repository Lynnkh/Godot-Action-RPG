extends Node2D

func create_grass_effect():
	#GrassEffect 是 場景.tsch
	#grassEffect 是 Node
	var GrassEffect = preload("res://Effects/grass_effect.tscn")
	var grassEffect = GrassEffect.instantiate()
		
	#world 是 Node
	#加入grassEffect
	#grassEffect位置是Grass位置
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position

#連接信號
func _on_hurt_box_area_entered(area):
	create_grass_effect()
	#催毀Grass Node2D
	queue_free()
