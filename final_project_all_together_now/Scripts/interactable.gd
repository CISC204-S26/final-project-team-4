class_name Interactable extends Area2D
@export var interaction_name = "test interaction"
@export var interaction_type = "test"
@export var display_active = false

# Called when the node enters the scene tree for the first time.
func interact():
	push_warning("this interactable has no interact() code yet!")
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
