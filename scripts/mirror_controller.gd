extends StaticBody3D
class_name Mirror

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reset() -> void:
	show();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func playDestroyAnimation() -> void:
	hide();
	print("mirror destroyed")
