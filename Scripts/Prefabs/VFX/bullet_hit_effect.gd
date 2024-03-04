extends Node3D

func _ready() -> void:
	$GPUParticles3D.emitting = true
	get_tree().create_timer(6.0).timeout.connect(queue_free)
