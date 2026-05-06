extends Area2D

var current_mode = 1
var mode_2_unlock = false
var mode_3_unlock = false
var ability11_cooldown = 0
var ability12_cooldown = 0
var ability22_cooldown = 0
var ability23_cooldown = 0

var bullet = preload("res://Scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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


func follow_mouse():
	position = get_global_mouse_position()


func swap_modes(mode):
	current_mode = current_mode + mode
	if current_mode > 3:
		current_mode = 1
	if current_mode < 1:
		current_mode = 3
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
			get_tree().root.add_child(bullet.instantiate())
			ability11_cooldown = 25
	if current_mode == 2:
		pass
	if current_mode == 3:
		pass


func ability2():
	if current_mode == 1:
		pass
	if current_mode == 2:
		pass
	if current_mode == 3:
		pass
