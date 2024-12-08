extends Node3D

var is_open: bool = false
@export var is_locker: bool = false

func open():
	$AnimationPlayer.play("open")
	is_open = true

func close():
	$AnimationPlayer.play_backwards("open")
	is_open = false
	
func _on_interactable_interacted(interactor):
	if is_open:
		close()
	else:
		open()
