extends Area2D

var current_mode = 1
var ability11_cooldown = 0
var ability12_cooldown = 0
var ability22_cooldown = 0
var ability23_cooldown = 0
var mouse_usable = true

@export var player: Node2D;
var can_grapple = false;

@onready var laser = get_node("Line2D");
var can_shoot_laser = false;

var bullet = preload("res://Scenes/bullet.tscn")
var block = preload("res://Scenes/power_block.tscn")

var interactables = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("left_click") && can_shoot_laser:
		update_laser();
	else:
		laser.visible = false;
			
	if mouse_usable == true:
		follow_mouse()
		if Input.is_action_just_pressed("scroll_up"):
			swap_modes(1)
		if Input.is_action_just_pressed("scroll_down"):
			swap_modes(-1)
		if Input.is_action_just_pressed("left_click"):
			ability1()
	if Input.is_action_just_pressed("right_click"):
		ability2()
	if ability11_cooldown > 0:
		ability11_cooldown = ability11_cooldown - 1
	if ability12_cooldown > 0:
		ability12_cooldown = ability12_cooldown - 1
	if ability22_cooldown > 0:
		ability22_cooldown = ability22_cooldown - 1
	if ability23_cooldown > 0:
		ability23_cooldown = ability23_cooldown - 1
		if ability23_cooldown == 0:
			mouse_usable = true


func follow_mouse():
	position = get_global_mouse_position()


func swap_modes(mode):
	current_mode = current_mode + mode
	if current_mode > 3:
		current_mode = 1
	if current_mode < 1:
		current_mode = 3
	if GlobalVariable.mode_2_unlock == false:
		pass
		if current_mode == 2:
			current_mode = 3
	if GlobalVariable.mode_3_unlock == false:
		pass
		if current_mode == 3:
			current_mode = 1
	if current_mode == 1:
		$Crosshair1.show()
		$Crosshair2.hide()
		$Crosshair3.hide()
	if current_mode == 2:
		$Crosshair1.hide()
		$Crosshair2.show()
		$Crosshair3.hide()
	if current_mode == 3:
		$Crosshair1.hide()
		$Crosshair2.hide()
		$Crosshair3.show()


func ability1():
	if current_mode == 1:
		if ability11_cooldown < 1:
			var shot = bullet.instantiate()
			shot.direction = Vector2(0, 0)
			shot.power = 25
			get_tree().root.add_child(shot)
			ability11_cooldown = 50
			
	if current_mode == 2:
		if ability12_cooldown < 1:
			var shot1 = bullet.instantiate()
			shot1.direction = Vector2(-1, -1)
			shot1.power = 10
			get_tree().root.add_child(shot1)
			var shot2 = bullet.instantiate()
			shot2.direction = Vector2(0, -1)
			shot2.power = 10
			get_tree().root.add_child(shot2)
			var shot3 = bullet.instantiate()
			shot3.direction = Vector2(1, -1)
			shot3.power = 10
			get_tree().root.add_child(shot3)
			var shot4 = bullet.instantiate()
			shot4.direction = Vector2(-1, 0)
			shot4.power = 10
			get_tree().root.add_child(shot4)
			var shot5 = bullet.instantiate()
			shot5.direction = Vector2(-1, 1)
			shot5.power = 10
			get_tree().root.add_child(shot5)
			var shot6 = bullet.instantiate()
			shot6.direction = Vector2(0, 0)
			shot6.power = 10
			get_tree().root.add_child(shot6)
			var shot7 = bullet.instantiate()
			shot7.direction = Vector2(1, 1)
			shot7.power = 10
			get_tree().root.add_child(shot7)
			var shot8 = bullet.instantiate()
			shot8.direction = Vector2(0, 1)
			shot8.power = 10
			get_tree().root.add_child(shot8)
			var shot9 = bullet.instantiate()
			shot9.direction = Vector2(1, 0)
			shot9.power = 10
			get_tree().root.add_child(shot9)
			ability12_cooldown = 150
	if current_mode == 3:
		can_shoot_laser = true;
	else:
		can_shoot_laser = false;

func ability2():
	if current_mode == 1:
		if interactables:
			interactables[-1].toggler()
	if current_mode == 2:
		player.can_grapple = true;
	else:
		player.can_grapple = false;
	if current_mode == 3:
		if mouse_usable == true:
			get_tree().root.add_child(block.instantiate())
			mouse_usable = false
			ability23_cooldown = 250
		else:
			mouse_usable = true

func update_laser() -> void:
	var space_state = get_world_2d().direct_space_state;
	var start = player.global_position;
	var mouse_pos = get_global_mouse_position();
	var offset = mouse_pos - start;
	var direction = offset.normalized();
	var end = start + direction;
	var query = PhysicsRayQueryParameters2D.create(start, end);
	query.collide_with_areas = true;
	query.collide_with_bodies = true;
	query.exclude = [player.get_rid()];
	#query.exclude = [$"../../Mouse".get_rid()];
	var hit = space_state.intersect_ray(query);
	
	laser.visible = true;

	laser.clear_points();
	laser.add_point(laser.to_local(player.global_position));
	laser.add_point(laser.to_local(global_position));

func _on_area_entered(area: Area2D) -> void:
	interactables.append(area)


func _on_area_exited(area: Area2D) -> void:
	interactables.erase(area)
