extends Node2D

@onready var animateSprite = $AnimatedSprite2D

func _ready():
	#設定第一個frame
	#播放動畫
	animateSprite.frame = 0
	animateSprite.play("Animate")

func _on_animated_sprite_2d_animation_finished():
	#毀滅
	queue_free()
