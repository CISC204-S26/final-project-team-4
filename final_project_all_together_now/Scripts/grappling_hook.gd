extends Node2D

@export var player: Node2D; #set this to player which this scene should be a child of

@onready var cable = get_node("Line2D");

var is_grappling = false;
var is_shooting = false;

var hook_point = Vector2.ZERO;
var should_hook = false;
var can_grapple = false;

@export var hook_speed = 400.0;
@export var max_hook_distance = 800.0;
@export var hook_shoot_speed = 2400.0;

func _physics_process(delta: float) -> void:
	can_grapple = player.can_grapple; #make sure this is the same as player's can_grapple var
	
	if (!is_grappling && !is_shooting):
		look_at(get_global_mouse_position()); #point toward mouse if not currently grappling
		
	if (Input.is_action_just_pressed("right_click") && can_grapple):
		
		should_hook = !should_hook; #set should hook to true if false and false if true
		
	if (should_hook):
		if (!is_grappling && !is_shooting):
			shoot_hook();
	else:
		cancel_hook();
	
	if (!can_grapple):
		cancel_hook();
	
	if (is_shooting):
		move_hook_to_target(delta);
		
	if is_grappling:
		if player.is_grappling == false:
			reset_hook();
		
	update_cable();
	
func shoot_hook() -> void:
	if (player == null):
		print("No player assigned to grappling hook!");
		return;
	
	var space_state = get_world_2d().direct_space_state;
	
	var start = player.global_position;
	var mouse_pos = get_global_mouse_position();
	var offset = mouse_pos - start;
	
	if offset.length() < 1:
		print("Offset length less than 1!");
		should_hook = false;
		return;
		
	var direction = offset.normalized();
	var end = start + direction * max_hook_distance;
	
	var query = PhysicsRayQueryParameters2D.create(start, end);
	query.collide_with_areas = true;
	query.collide_with_bodies = true;
	
	if player is CollisionObject2D:
		#exclude player and mouse from raycast query temporarily before we organize layers
		query.exclude = [player.get_rid(), $"../../Mouse".get_rid()];
	
	var hit = space_state.intersect_ray(query);
	
	if hit:
		hook_point = hit.position;
		
		reparent(get_tree().current_scene, true); #detach from player
		
		global_position = player.global_position; #start hook at player position
		
		is_shooting = true;
	else:
		print("Raycast hit nothing!");
		should_hook = false;

func move_hook_to_target(delta: float) -> void:
	global_position = global_position.move_toward(hook_point, hook_shoot_speed * delta);
	
	if global_position.distance_to(hook_point) <= 2:
		global_position = hook_point;
		is_shooting = false;
		is_grappling = true;
		player.start_grapple(hook_point, hook_speed);

func cancel_hook() -> void:
	if is_grappling:
		player.end_grapple();
	
	if (is_shooting || is_grappling):
		reset_hook();

func reset_hook() -> void:
	is_shooting = false;
	is_grappling = false;
	should_hook = false;
	
	reparent(player, false);
	position = Vector2.ZERO;

func update_cable() -> void:
	cable.visible = is_shooting || is_grappling;

	cable.clear_points();
	
	if (!cable.visible):
		return;
	
	cable.add_point(cable.to_local(player.global_position));
	cable.add_point(cable.to_local(global_position));
