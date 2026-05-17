extends CharacterBody2D

@export var nearby_interactables = []
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var cooldown = 0
var starting_pos = Vector2(0, 0)

#grappling vars
var is_grappling = false;
var grapple_target = Vector2.ZERO;
var grapple_cable_length = 0.0;
var grapple_speed = 600.0;

var can_grapple = false;

var grapple_release_timer = 0.0;

@export var grapple_release_control_delay = 0.15;
@export var air_control_acceleration = 900.0;

@export var swing_acceleration = 1400.0;
@export var max_swing_speed = 900.0;
@export var swing_damping = 0.995;
@export var grapple_release_drag = 450.0;
@export var grapple_pull_speed = 150.0;
@export var grapple_min_cable_length = 48.0;

func _physics_process(delta: float) -> void:
	#grappling code
	if (is_grappling && can_grapple):
		GlobalVariable.grapple = true;
		velocity += get_gravity() *delta; #apply gravity during swing
		
		#get direction from hook anchor to player
		var cable_vector = global_position - grapple_target;
		var cable_distance = cable_vector.length();
		
		#pull or push player toward grapple point
		if Input.is_action_pressed("interact"):
			grapple_cable_length = move_toward(grapple_cable_length, grapple_min_cable_length, grapple_pull_speed * delta);
		elif Input.is_action_pressed("interact_2"):
			grapple_cable_length += grapple_pull_speed * delta;
		
		if (cable_distance > 0):
			var cable_dir = cable_vector.normalized();
			var tangent = Vector2(cable_dir.y, -cable_dir.x);
			var swing_input := Input.get_axis("move_left", "move_right");
			velocity += tangent * swing_input * swing_acceleration * delta;
			velocity *= swing_damping
			
			if (velocity.length() > max_swing_speed):
				velocity = velocity.normalized() * max_swing_speed;
		
		move_and_slide();
		
		#cable constraint, prevents player from moving farther than cable length
		cable_vector = global_position - grapple_target;
		cable_distance = cable_vector.length();
		
		if (cable_distance > grapple_cable_length):
			var cable_dir = cable_vector.normalized();
			global_position = grapple_target + cable_dir * grapple_cable_length;
			
			#remove velocity moving away from hook
			var outward_speed = velocity.dot(cable_dir);
			if (outward_speed > 0):
				velocity -= cable_dir * outward_speed;
		
		return;
	else:
		GlobalVariable.grapple = false;

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")

	if not is_on_floor():
		# Air movement
		
		if grapple_release_timer > 0:
			grapple_release_timer -= delta
			
			#light air control after releasing grapple
			if direction:
				velocity.x += direction * air_control_acceleration * delta
			
			#slowly kill off grapple momentum over time
			velocity.x = move_toward(velocity.x, 0, grapple_release_drag * delta)
		
		else:
			#normal air control when not recently grappling
			var target_air_speed = direction * SPEED
			velocity.x = move_toward(velocity.x, target_air_speed, air_control_acceleration * delta)

	else:
		#ground movement
		grapple_release_timer = 0
		
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
	
	grapple_cable_length = global_position.distance_to(grapple_target);
	
	grapple_cable_length = max(grapple_cable_length, 32.0);

func end_grapple() -> void:
	if is_grappling:
			grapple_release_timer = grapple_release_control_delay;
	is_grappling = false;

#Customization
#------------------------------

@onready var helmets = [$RedHelmet, $OrangeHelmet, $YellowHelmet, $GreenHelmet, $BlueHelmet, $PurpleHelmet]

func apply_customization():
	for h in helmets:
		if h: 
			h.visible = false

	var target_index = GlobalVariable.selected_helmet_index
	print("PLAYER RECEIVED HELMET INDEX: ", target_index)
	
	if target_index >= 0 and target_index < helmets.size():
		if helmets[target_index]:
			helmets[target_index].visible = true
	else:
		if helmets[0]:
			helmets[0].visible = true
			
func _ready():
	print("--- PLAYER HAS SPAWNED IN THE LEVEL ---")
	apply_customization()
	starting_pos = position


func take_damage():
	position = starting_pos


func _on_area_2d_body_entered(body: Node2D) -> void:
	take_damage()
	$"../enemy_grappler".position = Vector2(538.0, 108.0)
