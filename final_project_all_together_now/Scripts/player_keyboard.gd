extends CharacterBody2D

@export var nearby_interactables = []
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var cooldown = 0

#grappling vars
var is_grappling = false;
var grapple_target = Vector2.ZERO;
var grapple_speed = 600.0;

var can_grapple = false;

func _physics_process(delta: float) -> void:
	#grappling code
	if (is_grappling && can_grapple):
		GlobalVariable.grapple = true

		var direction_to_target = global_position.direction_to(grapple_target);
		velocity = direction_to_target * grapple_speed;
		
		move_and_slide();
		return;
	else:
		GlobalVariable.grapple = false

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

#grappling functions
func start_grapple(target_pos: Vector2, speed: float) -> void:
	is_grappling = true;
	grapple_target = target_pos;
	grapple_speed = speed;

func end_grapple() -> void:
	is_grappling = false;

#Customization
#------------------------------

@onready var helmets = [
	$RedHelmet,
	$OrangeHelmet,
	$YellowHelmet,
	$GreenHelmet,
	$BlueHelmet,
	$PurpleHelmet
]

func _ready():
	apply_customization()

func apply_customization():
	for h in helmets:
		if h: 
			h.visible = false

	var selected_helmet_index: int = 0
	var index = GlobalVariable.selected_helmet_index
	
	if index >= 0 and index < helmets.size():
		var chosen_helmet = helmets[index]
		if chosen_helmet:
			chosen_helmet.visible = true
	else:
		helmets[0].visible = true
