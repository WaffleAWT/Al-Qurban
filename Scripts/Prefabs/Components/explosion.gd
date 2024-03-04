extends Area3D

#Data
@export var damage : float = 40.0

func explode() -> void:
	$AudioStreamPlayer3D.playing = true
	$GPUParticles3D.emitting = true
	$GPUParticles3D2.emitting = true
	var query = PhysicsShapeQueryParameters3D.new()
	query.transform = global_transform
	query.shape = $CollisionShape3D.shape
	query.collision_mask = collision_mask
	var space_state = get_world_3d().direct_space_state
	var results = space_state.intersect_shape(query)
	for data in results:
		if data.collider.has_method("hurt"):
			if data.collider.health <= damage:
				var random_number : int = randi_range(1, 4)
				if random_number > 2:
					FrameFreeze.frame_freeze(0.05, 1.0)
			data.collider.hurt(damage, global_transform.origin.direction_to(data.collider.global_transform.origin))
