extends Node3D

#Data
var spawned : bool = false
var gib_position : Vector3
var bone_position : Vector3
var gib_rotation : Vector3
var bone_rotation : Vector3

#Refrences
@export var hole : Node3D
@export var bone : PackedScene
@export var gib : PackedScene

func _ready() -> void:
	bone_position = $Bone.global_position
	bone_rotation = $Bone.rotation
	gib_position = $Gib.global_position
	gib_rotation = $Gib.rotation

func _physics_process(delta: float) -> void:
	if hole.gibs > 1 and hole.bones > 1:
		$UI/Label.visible = false
		$UI/Label2.visible = true
		if not spawned:
			var bone_instance = bone.instantiate()
			get_tree().current_scene.add_child(bone_instance)
			bone_instance.global_position = bone_position
			bone_instance.rotation = bone_rotation
			var gib_instance = gib.instantiate()
			get_tree().current_scene.add_child(gib_instance)
			gib_instance.global_position = gib_position
			gib_instance.rotation = gib_rotation
			spawned = true
