extends Control



func _on_play_pressed():
	get_tree().change_scene_to_file("res://UI/level_selection_screen.tscn")


func _on_editor_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
