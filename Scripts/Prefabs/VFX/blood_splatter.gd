extends GPUParticles3D

func _ready() -> void:
	get_tree().create_timer(2.0).timeout.connect(queue_free)
