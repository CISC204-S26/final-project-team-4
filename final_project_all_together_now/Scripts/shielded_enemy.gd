extends Node2D

@export var health = 100
@export var start_position = Vector2(0, 0)
var shield = true
var aggro = false
var target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("normal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health < 1:
		queue_free()
	if shield == false:
		if aggro == true:
			var direction = global_position.direction_to(target.position)
			position = position + direction
		if position != start_position:
			if aggro == false:
				var direction = global_position.direction_to(start_position)
				position = position + direction
				if position.distance_to(start_position) < 10:
					position = start_position
					shield = true
					$AnimatedSprite2D.play("normal")


func damage(power):
	if shield == false:
		health = health - power


func _on_detector_body_entered(body: Node2D) -> void:
	shield = false
	aggro = true
	target = body
	$AnimatedSprite2D.play("angy")


func _on_detector_body_exited(body: Node2D) -> void:
	aggro = false
