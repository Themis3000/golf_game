extends Control

var levels_path = "res://levels_builtin/"
var dir = DirAccess.open(levels_path)
var base_level_item = preload("res://UI/level_select.tscn")
var level_builder = preload("res://level_builder/level_builder.tscn")

func load_level(file: String):
	var level = level_builder.instantiate()
	get_tree().root.add_child(level)
	level.load_level(file)
	get_tree().root.remove_child(self)
	self.queue_free()

func _ready():
	var container = get_node("ScrollContainer/VBoxContainer")
	var files = dir.get_files()
	for file in files:
		var full_path = levels_path + file
		if not file.ends_with(".json"):
			continue
		
		var level_name = file.left(-5)
		var menu_item = base_level_item.instantiate()
		
		var label = menu_item.get_node("Label")
		label.set_text(level_name)
		
		var button = menu_item.get_node("Button")
		button.pressed.connect(func(): load_level(full_path))
		
		container.add_child(menu_item)
