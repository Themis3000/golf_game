extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# This is temporary and for testing purposes. Remove later.
	LevelSerializer.serialize_level("test.json", self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		SignalManager.restart_level.emit()
