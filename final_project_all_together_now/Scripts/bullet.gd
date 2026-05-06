extends Area2D

var life_time = 100
@export var power = 25
@export var direction = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_global_mouse_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position + direction
	life_time = life_time - 1
	if life_time < 1:
		queue_free()


func _on_area_entered(enemy: Area2D) -> void:
	enemy.damage(power)
	queue_free()
