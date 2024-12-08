extends Control


func _input(event):
	if event is InputEventMouseMotion:
		print(event.position)
