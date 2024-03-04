extends Area3D
class_name Hitbox

#Signals
signal hurt_hitbox

#Data
@export var weak_spot : bool = false
@export var critical_multiplier : float = 2

func hurt(damage : float, direction : Vector3) -> void:
	if weak_spot:
		hurt_hitbox.emit(damage * critical_multiplier, direction)
	else:
		hurt_hitbox.emit(damage, direction)
