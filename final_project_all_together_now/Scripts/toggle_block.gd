extends Area2D

@export var is_active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_active == false:
		$Sprite2D.hide()
		$CollisionShape2D.set_deferred("disabled", true)
	if is_active == true:
		$Sprite2D.show()
		$CollisionShape2D.set_deferred("disabled", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func toggle():
	is_active = !is_active
	if is_active == false:
		$Sprite2D.hide()
		$CollisionShape2D.set_deferred("disabled", true)
	if is_active == true:
		$Sprite2D.show()
		$CollisionShape2D.set_deferred("disabled", false)


func _on_machine_toggle() -> void:
	toggle()
