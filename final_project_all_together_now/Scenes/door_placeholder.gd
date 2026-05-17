extends Area2D

@export_file("*.tscn") var next_scene: String
@export var unlock = 0

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Touched: ", body.name)

	if body.is_in_group("player"):
		print("PLAYER DETECTED")
		get_tree().change_scene_to_file(next_scene)
		if unlock == 2:
			GlobalVariable.mode_2_unlock = true
		if unlock == 3:
			GlobalVariable.mode_3_unlock = true
