extends Node3D

var view_point: Vector3
@onready var mini_game = $SubViewport/viewport/MiniGame
var camera2d: Camera2D
@onready var monitor_mesh = $Mesh_Monitor_003/Mesh_Monitor_003_001
@onready var viewport = $SubViewport
@onready var camera = $Camera3D
@onready var original_camera_transform = camera.global_transform
var quad_mesh_size
var is_mouse_inside = false
var is_mouse_held = false
var is_opened = false;
var last_mouse_pos3D = null
var last_mouse_pos2D = null
@onready var node_area = $Area3D

func _ready():
	viewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	view_point = $viewPoint.global_position
	node_area.mouse_entered.connect(self._mouse_entered_area)

func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		if is_opened:
			escape()
	
	var is_mouse_event = false
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event):
			is_mouse_event = true
			break
	if not is_opened:
		return
	if is_mouse_event and (is_mouse_inside or is_mouse_held):
		handle_mouse(event)
	elif not is_mouse_event:
		viewport.push_input(event)

func _mouse_entered_area():
	is_mouse_inside = true
	print("entered")


func handle_mouse(event):
	quad_mesh_size = Vector2(2.0, 2.0)
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		is_mouse_held = event.pressed

	var mouse_pos3D = find_mouse(event.global_position)
	is_mouse_inside = mouse_pos3D != null
	if is_mouse_inside:
		mouse_pos3D = node_area.global_transform.affine_inverse() * mouse_pos3D
		last_mouse_pos3D = mouse_pos3D
	else:
		mouse_pos3D = last_mouse_pos3D
		if mouse_pos3D == null:
			mouse_pos3D = Vector3.ZERO

	var mouse_pos2D = Vector2(mouse_pos3D.x, -mouse_pos3D.y)
	mouse_pos2D.x += quad_mesh_size.x / 2
	mouse_pos2D.y += quad_mesh_size.y / 2
	mouse_pos2D.x = mouse_pos2D.x / quad_mesh_size.x
	mouse_pos2D.y = mouse_pos2D.y / quad_mesh_size.y
	mouse_pos2D.x = mouse_pos2D.x * viewport.size.x
	mouse_pos2D.y = mouse_pos2D.y * viewport.size.y
	event.position = mouse_pos2D
	event.global_position = mouse_pos2D

	if event is InputEventMouseMotion:
		if last_mouse_pos2D == null:
			event.relative = Vector2(0, 0)
		else:
			event.relative = mouse_pos2D - last_mouse_pos2D
	last_mouse_pos2D = mouse_pos2D
	viewport.push_input(event)

func find_mouse(global_position):
	var player_camera = get_viewport().get_camera_3d()
	var dist = find_further_distance_to(player_camera.transform.origin)

	var parameters = PhysicsRayQueryParameters3D.new()
	parameters.from = player_camera.project_ray_origin(global_position)
	parameters.to = parameters.from + player_camera.project_ray_normal(global_position) * dist

	parameters.collision_mask = node_area.collision_layer
	parameters.collide_with_bodies = false
	parameters.collide_with_areas = true
	var result = get_world_3d().direct_space_state.intersect_ray(parameters)

	if result.size() > 0:
		return result.position
	else:
		return null


func find_further_distance_to(origin):
	var edges = []
	edges.append(node_area.to_global(Vector3(quad_mesh_size.x / 2, quad_mesh_size.y / 2, 0)))
	edges.append(node_area.to_global(Vector3(quad_mesh_size.x / 2, -quad_mesh_size.y / 2, 0)))
	edges.append(node_area.to_global(Vector3(-quad_mesh_size.x / 2, quad_mesh_size.y / 2, 0)))
	edges.append(node_area.to_global(Vector3(-quad_mesh_size.x / 2, -quad_mesh_size.y / 2, 0)))

	var far_dist = 0
	var temp_dist
	for edge in edges:
		temp_dist = origin.distance_to(edge)
		if temp_dist > far_dist:
			far_dist = temp_dist

	return far_dist

func _on_interactable_interacted(interactor):
	if interactor as Node:
		var player_camera = get_viewport().get_camera_3d()
		var transform_from = player_camera.global_transform
		var transform_to = camera.global_transform
		var tween = create_tween()
		tween.tween_property(camera, "global_transform", transform_from, 0)
		tween.tween_property(camera, "global_transform", transform_to, 0.5)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		camera.current = true
		is_opened = true
		
	print("computer loading")

func escape():
	camera.global_transform = original_camera_transform
	for c in get_tree().get_nodes_in_group("player_camera"):
		var transform_from = camera.global_transform
		var transform_to = c.global_transform
		var tween = create_tween()
		tween.tween_property(c, "global_transform", transform_from, 0)
		tween.tween_property(c, "global_transform", transform_to, 0.5)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		c.current = true
		break
	is_opened = false;
