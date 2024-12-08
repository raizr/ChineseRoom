@tool
extends Node3D


func _ready():
	var viewport = $SubViewport
	$SubViewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	$Mesh_Monitor_003/Mesh_Monitor_003_001.material_override.albedo_texture = viewport.get_texture()
	$MeshInstance3D.material_override.albedo_texture = viewport.get_texture()
