extends AnimatedSprite2D

func _ready():
	
	#使用code連接訊號，能不需要手動連接訊號，使用腳本本身的方法
	connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	#設定第一個frame
	#播放動畫
	frame = 0
	play("Animate")

func _on_animation_finished():
	#毀滅
	queue_free()
