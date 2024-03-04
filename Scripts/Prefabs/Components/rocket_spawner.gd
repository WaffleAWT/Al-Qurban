extends Node3D

#Data
var bodies_to_exclude : Array = []
var damage : float = 1.0

#Refrences
@export var rocket : PackedScene

func set_damage(_damage : float) -> void:
	damage = _damage

func set_bodies_to_exclude(_bodies_to_exclude : Array) -> void:
	bodies_to_exclude = _bodies_to_exclude

func fire() -> void:
	var rocket_instance = rocket.instantiate()
	rocket_instance.set_bodies_to_exclude(bodies_to_exclude)
	get_tree().current_scene.add_child(rocket_instance)
	rocket_instance.global_transform = global_transform
	rocket_instance.impact_damage = damage
