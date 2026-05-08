extends Node2D

@export var player: Node2D; #set this to player which this scene should be a child of

@onready var cable = get_node("Line2D");

var is_grappling = false;
var hook_point = Vector2.ZERO;

var should_hook = false;

var can_grapple = false;

@export var hook_speed = 400.0;
@export var max_hook_distance = 800.0;

func _physics_process(delta: float) -> void:
	#set cable between player and hook
	cable.add_point(Vector2(100, 50));
	cable.add_point(Vector2(100, 50));
	
	update_cable();
	
	can_grapple = player.can_grapple; #make sure this is the same as player's can_grapple var
	if (!is_grappling):
		look_at(get_global_mouse_position()); #point toward mouse if not currently grappling
		
	if (Input.is_action_just_pressed("right_click") && can_grapple):
		should_hook = !should_hook; #set should hook to true if false and false if true
		
	if (should_hook):
		if (!is_grappling):
			shoot_hook();
	else:
		player.end_grapple();
	
	if (!can_grapple):
		if (is_grappling):
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
		#exclude player and mouse from raycast query temporarily before we organize layers
		query.exclude = [player.get_rid()];
		query.exclude = [$"../../Mouse".get_rid()];
	
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

func update_cable() -> void:
	cable.visible = true;

	cable.clear_points();
	cable.add_point(cable.to_local(player.global_position));
	cable.add_point(cable.to_local(global_position));
