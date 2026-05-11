extends CharacterBody2D
var speed = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if GlobalVariable.grapple == true:
		print("Enemy pos: ", global_position)
		print("Player pos: ", $"../playerKeyboard".global_position)
		var direction = global_position.direction_to($"../playerKeyboard".global_position)
		print("Direction: ", direction)
		velocity = direction * speed
		move_and_slide()
