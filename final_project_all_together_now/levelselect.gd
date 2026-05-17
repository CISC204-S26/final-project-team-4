extends Node2D

func _on_level_1_button_pressed() -> void:
	var error_code = get_tree().change_scene_to_file("res://Scenes/start_floor.tscn")
	if error_code != OK:
		print("ERROR: Could not load Level 1. Check your file path or file spelling!")

func _on_level_2_button_pressed() -> void:
	var error_code = get_tree().change_scene_to_file("res://Scenes/Level2.tscn")
	if error_code != OK:
		print("ERROR: Could not load Level 2. Check your file path or file spelling!")

func _on_level_3_button_pressed() -> void:
	var error_code = get_tree().change_scene_to_file("res://Scenes/final_room.tscn")
	if error_code != OK:
		print("ERROR: Could not load Level 3. Check your file path or file spelling!")

func _on_back_button_pressed() -> void:
	print("Back Button Clicked! Trying to load title screen...")
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
