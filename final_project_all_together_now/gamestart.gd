extends Button


@export_file("*.tscn") var scene_to_load: String

func _ready():
	self.pressed.connect(_on_self_pressed)

func _on_self_pressed():
	if scene_to_load != "":
		get_tree().change_scene_to_file(scene_to_load)
	else:
		print("Warning: No scene assigned to the Start Button!")
