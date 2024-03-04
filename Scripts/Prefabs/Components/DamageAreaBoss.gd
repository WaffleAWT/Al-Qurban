extends Area3D

#Data
var bodies_to_exclude : Array = []
var damage : float = 100.0

func set_damage(_damage : float) -> void:
	damage = _damage

func set_bodies_to_exclude(_bodies_to_exclude : Array) -> void:
	bodies_to_exclude = _bodies_to_exclude

func fire() -> void:
	if monitoring:
		for body in get_overlapping_bodies():
			if body.has_method("hurt") and !body in bodies_to_exclude:
				body.hurt(damage, global_transform.origin.direction_to(body.global_transform.origin))
