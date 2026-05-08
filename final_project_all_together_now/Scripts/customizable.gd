extends Node2D

var hair_images: Array = []
var face_images: Array = []
var body_images: Array = []

var h_idx: int = 0
var f_idx: int = 0
var b_idx: int = 0

var customization_string: String = ""

@onready var display_label = $CustomizationLabel 
@onready var input_field = $LineEdit            

func _ready():
	hair_images = [$"Teruteru Head", $"Shuichi Head", $"Taka Head", $"Kaito Head", $"Mondo Head"] 
	face_images = [$"Face - Color 1", $"Face - Color 2", $"Face - Color 3", $"Face - Color 4", $"Face - Color 5", $"Face - Color 6"]
	body_images = [$"Teruteru Body", $"Shuichi Body", $"Taka Body", $"Kaito Body", $"Mondo Body"]
	
	reset_visibility()
	sync_view_to_model()

func reset_visibility():
	for list in [hair_images, face_images, body_images]:
		for img in list:
			if img: 
				img.visible = false

func sync_view_to_model():
	hair_images[h_idx].visible = true
	face_images[f_idx].visible = true
	body_images[b_idx].visible = true
	
	customization_string = str(h_idx) + str(f_idx) + str(b_idx)
	
	if display_label:
		display_label.text = "Customization String: " + customization_string

func _on_line_edit_text_submitted(new_text: String):
	if new_text.length() == 3 and new_text.is_valid_int():
		reset_visibility()
		
		h_idx = int(new_text.substr(0, 1))
		f_idx = int(new_text.substr(1, 1))
		b_idx = int(new_text.substr(2, 1))
		
		h_idx = clamp(h_idx, 0, hair_images.size() - 1)
		f_idx = clamp(f_idx, 0, face_images.size() - 1)
		b_idx = clamp(b_idx, 0, body_images.size() - 1)
		
		sync_view_to_model()

func _on_hair_button_pressed():
	hair_images[h_idx].visible = false 
	h_idx = (h_idx + 1) % hair_images.size()
	sync_view_to_model()

func _on_hair_back_pressed():
	hair_images[h_idx].visible = false 
	h_idx -= 1
	if h_idx < 0:
		h_idx = hair_images.size() - 1
	sync_view_to_model() 

func _on_face_button_pressed():
	face_images[f_idx].visible = false
	f_idx = (f_idx + 1) % face_images.size()
	sync_view_to_model()

func _on_face_back_pressed():
	face_images[f_idx].visible = false
	f_idx -= 1
	if f_idx < 0:
		f_idx = face_images.size() - 1
	sync_view_to_model()

func _on_body_button_pressed():
	body_images[b_idx].visible = false
	b_idx = (b_idx + 1) % body_images.size()
	sync_view_to_model()

func _on_body_back_pressed():
	body_images[b_idx].visible = false
	b_idx -= 1
	if b_idx < 0:
		b_idx = body_images.size() - 1
	sync_view_to_model()
