extends Area2D

var  player = null

#檢測player在區域中
func can_seek_player():
	return player != null

#檢測player進入區域
func _on_body_entered(body: Node2D) -> void:
	player = body

#檢測player退出區域
func _on_body_exited(body: Node2D) -> void:
	player = null
