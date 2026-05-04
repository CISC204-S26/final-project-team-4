extends Node2D

var shoot_hook: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#check moues input, if true
		#shoot_hook = true;
	
	if (shoot_hook):
		_shoot_hook();
		shoot_hook = false; #reset shoot_hook

func _shoot_hook() -> void:
	#code here for actually shooting the hook
	pass
