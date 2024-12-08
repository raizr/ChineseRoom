extends Node3D
class_name SwitchSelector

@export var answer : String

signal onPress

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interactable_click() -> void:
	onPress.emit()
	print(answer)
