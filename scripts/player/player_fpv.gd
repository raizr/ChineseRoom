extends CharacterBody3D

class_name Player

@onready var camera = $Head/CameraPlayer
var mouseSensibility = 2200
var mouse_relative_x = 0
var mouse_relative_y = 0
const DIST = 100;
var grabbed_object = null
var mouse = Vector2()

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_relative_y = rotation.y 

func get_mouse_world_pos(mouse:Vector2) -> Interactable:
	#The physics state of the world
	var space = get_world_3d().direct_space_state
	#start and end world positions for the ray
	var start = get_viewport().get_camera_3d().project_ray_origin(mouse)
	var end = get_viewport().get_camera_3d().project_position(mouse,DIST)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end
	params.collide_with_areas = true
	#cast the ray using the space and return the results as a Dictionary
	var result = space.intersect_ray(params)
	print(result)
	if result.is_empty() == false:
		return result.collider as Interactable
	return null

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed == false and event.button_index == MOUSE_BUTTON_LEFT:
			var obj = get_mouse_world_pos(mouse)
			if obj:
				obj.click.emit()
	if event is InputEventMouseMotion:
		camera.rotation.x -= event.relative.y / mouseSensibility
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		var temp = event.relative.x / mouseSensibility
		if (rotation.y - temp < deg_to_rad(0) || rotation.y - temp > deg_to_rad(180)):
			return
		rotation.y -= temp;
		mouse = event.position
