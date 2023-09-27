extends Node2D


func load_level(path):
	print(path)
	LevelDeserializer.deserialize_level(path, self)
	SignalManager.level_loaded.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		SignalManager.restart_level.emit()
