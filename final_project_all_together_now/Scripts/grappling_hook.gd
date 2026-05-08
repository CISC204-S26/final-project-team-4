extends Node2D

@export var player: Node2D; #set this to player which this scene should be a child of

var is_grappling = false;
var hook_point = Vector2.ZERO;

@export var hook_speed = 400.0;
@export var max_hook_distance = 800.0;

func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("left_click")):
		shoot_hook();
	elif (Input.is_action_just_pressed("right_click")):
		player.end_grapple();
		
	if is_grappling:
		if player.is_grappling == false:
			is_grappling = false;
			reparent(player, false);
			position = Vector2.ZERO;
		

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
		return;
		
	var direction = offset.normalized();
	var end = start + direction * max_hook_distance;
	
	var query = PhysicsRayQueryParameters2D.create(start, end);
	query.collide_with_areas = true;
	query.collide_with_bodies = true;
	
	if player is CollisionObject2D:
		query.exclude = [player.get_rid()];
	
	var hit = space_state.intersect_ray(query);
	
	if hit:
		hook_point = hit.position;
		
		var grapple_target = hook_point - direction * 50;
		reparent(get_tree().current_scene,true); #detach from player and move to hook point
		global_position = hook_point;
		
		player.start_grapple(grapple_target, hook_speed);
		
		is_grappling = true;
	else:
		print("Raycast hit nothing!");
