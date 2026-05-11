extends Area2D

var life_time = 250

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_global_mouse_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if life_time < 1:
		disappear()
	if Input.is_action_just_pressed("right_click"):
		disappear()
	life_time = life_time - 1


func disappear():
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	disappear()
