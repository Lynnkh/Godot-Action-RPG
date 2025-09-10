extends AudioStreamPlayer

func _ready() -> void:
	# 當音效播完自動刪除自己
	finished.connect(queue_free)
