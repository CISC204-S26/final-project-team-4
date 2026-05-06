extends Node2D

@onready var mouse = get_node("res://Scenes/mouse.tscn");
var shoot_hook = false;
var target = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_pressed("left_click")):
		shoot_hook = true;
	
	if (shoot_hook):
		shoot_hook = false;
		
		var space_state = get_world_2d().direct_space_state;
		var start = global_position;
		var end = get_global_mouse_position();
		
		var raycast = PhysicsRayQueryParameters2D.create(start, end);
		
		var hook_target = space_state.intersect_ray(raycast);
		
		global_position = hook_target;
