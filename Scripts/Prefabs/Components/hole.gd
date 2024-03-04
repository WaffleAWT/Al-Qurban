extends Node3D

#Signals
signal hole_full

#Data
var gibs : int = 0
var bones : int = 0
var required_gibs : int = 10
var required_bones : int = 10

#Refrences
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	player.add_gib.connect(add_gib)
	player.add_bone.connect(add_bone)

func _process(_delta : float) -> void:
	if gibs >= required_gibs and required_bones >= required_bones:
		hole_full.emit()

func add_gib() -> void:
	gibs += 1
	if gibs > 0:
		$Gibs/Gib.visible = true
	if gibs > 3:
		$Gibs/Gib2.visible = true
	if gibs > 6:
		$Gibs/Gib3.visible = true
	if gibs > 9:
		$Gibs/Gib4.visible = true

func add_bone() -> void:
	bones += 1
	if bones > 0:
		$Bones/Bone.visible = true
	if bones > 3:
		$Bones/Bone2.visible = true
	if bones > 6:
		$Bones/Bone3.visible = true
	if bones > 9:
		$Bones/Bone4.visible = true
