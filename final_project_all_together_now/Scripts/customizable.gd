extends Node2D

var helmet_images: Array = []
var h_idx: int = 0
var customization_string: String = ""

@onready var display_label = $CustomizationLabel 
@onready var input_field = $LineEdit   
@export_file("*.tscn") var game_scene_path: String = ""         

func _ready():
	helmet_images = [$"RedHelmet", $"OrangeHelmet", $"YellowHelmet", $"GreenHelmet", $"BlueHelmet", $"PurpleHelmet"] 
	reset_visibility()
	sync_view_to_model()

func reset_visibility():
	for list in [helmet_images]:
		for img in list:
			if img: 
				img.visible = false

func sync_view_to_model():
	helmet_images[h_idx].visible = true
	
	customization_string = str(h_idx)
	
	if display_label:
		display_label.text = "Customization String: " + customization_string

func _on_line_edit_text_submitted(new_text: String):
	if new_text.length() == 3 and new_text.is_valid_int():
		reset_visibility()
		
		h_idx = int(new_text.substr(0, 1))
		
		h_idx = clamp(h_idx, 0, helmet_images.size() - 1)
		
		sync_view_to_model()

func _on_helmet_button_pressed():
	helmet_images[h_idx].visible = false 
	h_idx = (h_idx + 1) % helmet_images.size()
	sync_view_to_model()

func _on_helmet_back_pressed():
	helmet_images[h_idx].visible = false 
	h_idx -= 1
	if h_idx < 0:
		h_idx = helmet_images.size() - 1
	sync_view_to_model() 
	
func _on_start_button_pressed():
	GlobalVariable.selected_helmet_index = h_idx
	
	if game_scene_path != "":
		get_tree().change_scene_to_file(game_scene_path)
	else:
		print("Error: You haven't assigned a scene to game_scene_path in the Inspector!")
