extends CharacterBody2D

@export var nearby_interactables = []
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var cooldown = 0

func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("dash"):
		if cooldown == 0:
			cooldown += 50
			if direction == 0:
				velocity.x = 3000
			else:
				velocity.x = direction * SPEED * 40
	if cooldown > 0:
		cooldown -= 1
	if Input.is_action_just_pressed("interact"):
		if nearby_interactables:
			nearby_interactables.back().interact()
	move_and_slide()


func _on_detector_area_entered(area: Area2D) -> void:
	area.set_active = true
	nearby_interactables.append(area)
	print("in area")


func _on_detector_area_exited(area: Area2D) -> void:
	area.set_active = false
	nearby_interactables.erase(area)
	print("left area")
