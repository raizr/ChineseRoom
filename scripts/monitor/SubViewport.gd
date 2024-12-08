extends SubViewport

var view: Control

func _ready():
	view = $MiniGame

func _input(event):
	if event is InputEventMouseMotion:
		var mouseEvent = event.duplicate()
		mouseEvent.position = view.get_global_transform_with_canvas().affine_inverse() * event.position
		view.unhandled_input(mouseEvent)
