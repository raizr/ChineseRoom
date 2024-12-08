extends Node3D
@export var mirror : Mirror
@export var switchNO : SwitchSelector
@export var switchYES : SwitchSelector
@export var enemyPerson : Enemy
@export var animationPlayer : AnimationPlayer
@export var player : Player
@export var rooms: Array[Node3D]
var sceneInstance :  PackedScene
var currentRoom : int = 1
const MAX_ROOMS : int = 3
const ROOM_DISTANCE : float = -5.433

func _ready() -> void:
	sceneInstance = load("res://levels/base_room.tscn")
	rooms.resize(MAX_ROOMS)
	for i in range(MAX_ROOMS):
		rooms[i] = sceneInstance.instantiate()
		rooms[i].transform.origin.z += ROOM_DISTANCE * i;
		add_child(rooms[i])
	nextRoom()

func nextRoom() -> void:
	if (currentRoom >= MAX_ROOMS):
		return
	var room = rooms[currentRoom]
	#if (switchNO and switchNO.onPress.is_connected(_on_switch_no_on_press)):
		#switchNO.onPress.disconnect(_on_switch_no_on_press)
		#switchYES.onPress.disconnect(_on_switch_yes_on_press)
	player.reparent(room, true)
	player.position = Vector3(3.073, 0.5, 0.157)
	if (!switchNO):
		mirror = room.get_node("Mirror") as Mirror
		switchNO = room.get_node("switchNO") as SwitchSelector
		switchNO.onPress.connect(_on_switch_no_on_press)
		switchYES = room.get_node("switchYES") as SwitchSelector
		switchYES.onPress.connect(_on_switch_yes_on_press)
		enemyPerson = room.get_node("Enemy") as Enemy
	mirror.reset()
	#currentRoom += 1
	

func _process(delta: float) -> void:
	pass

func _on_switch_no_on_press() -> void:
	mirror.playDestroyAnimation()
	if enemyPerson.isPerson:
		print("is win")
	else:
		print("is score")
	animationPlayer.speed_scale = 1.0
	animationPlayer.play("move_right")


func _on_switch_yes_on_press() -> void:
	mirror.playDestroyAnimation()
	if enemyPerson.isPerson:
		print("you lose")
	else:
		print("is reward")
	animationPlayer.speed_scale = 1.0
	animationPlayer.play("move_right")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "move_right"):
		nextRoom()
