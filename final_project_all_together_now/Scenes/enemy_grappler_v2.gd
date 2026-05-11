extends CharacterBody2D


const SPEED = 500.0

func _physics_process(delta: float) -> void:
	if GlobalVariable.grapple == true:
		var target = $"../playerKeyboard".global_position
		var distance = global_position.distance_to(target)
		if distance > 5.0:  
			var direction = global_position.direction_to(target)
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	move_and_slide()
