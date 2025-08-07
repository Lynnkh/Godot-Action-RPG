extends Area2D

##偵測有沒有碰撞
func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

##給予推力Vector2
func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0]
		#獲取距離
		push_vector = area.global_position.direction_to(global_position)	
		
	return push_vector
