extends Node3D

#Data
@export var emit : bool = false
var emitted : bool = false

func _process(delta: float) -> void:
	if emit and not emitted:
		for child in get_children():
			child.emitting = true
		emitted = true
