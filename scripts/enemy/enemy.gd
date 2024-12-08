extends CharacterBody3D

class_name Enemy
@export var isDead : bool = false
@export var isPerson: bool = false
 
func _ready() -> void:
	isPerson = randi_range(0, 1)

func _on_collision_shape_3d_tree_entered() -> void:
	print("Enemy collision entered")
	isDead = true
