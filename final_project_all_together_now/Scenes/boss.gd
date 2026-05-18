extends Area2D

@export var health = 1000
var starting_position = 0
var move_left = false
var move_right = true
var move_up = false
var move_down = false
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_position = position
	new_direction()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health < 1:
		queue_free()
	if move_down == true:
		position = position + Vector2(0, 5)
		timer = timer + 1
		if timer > 49:
			new_direction()
			timer = 0
	if move_up == true:
		position = position + Vector2(0, -5)
		timer = timer + 1
		if timer > 49:
			new_direction()
			timer = 0
	if move_left == true:
		position = position + Vector2(-5, 0)
		timer = timer + 1
		if timer > 49:
			new_direction()
			timer = 0
	if move_right == true:
		position = position + Vector2(5, 0)
		timer = timer + 1
		if timer > 49:
			new_direction()
			timer = 0


func new_direction():
	if position != starting_position:
		position = starting_position
	if move_right == true:
		move_right = false
		move_down = true
	if move_up == true:
		move_up = false
		move_right = true
	if move_left == true:
		move_left = false
		move_up = true
	if move_down == true:
		move_down = false
		move_left = true


func damage(power):
	health = health - power
