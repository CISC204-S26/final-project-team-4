extends Area2D

var active = false
signal toggle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func toggler():
	active = !active
	if active == true:
		$Sprite2D.hide()
		$Sprite2D2.show()
	else:
		$Sprite2D.show()
		$Sprite2D2.hide()
	toggle.emit()
