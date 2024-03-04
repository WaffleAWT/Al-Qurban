extends Camera3D

#Data
var shake_duration : float = 0.5
var shake_intensity : float = 0.1
var initial_position : Vector3 = Vector3()

#Refrences
@export var shake_timer : Timer

#func _ready() -> void:
	#initial_position = global_transform.origin

func shake() -> void:
	initial_position = global_transform.origin
	shake_timer.start()

func _on_shake_timer_timeout() -> void:
	global_transform.origin = initial_position
	shake_timer.stop()

func _process(delta : float) -> void:
	if not shake_timer.is_stopped():
		var offset_x : float = randf_range(-shake_intensity, shake_intensity)
		var offset_y : float = randf_range(-shake_intensity, shake_intensity)
		var offset_z : float = randf_range(-shake_intensity, shake_intensity)
		
		global_transform.origin = initial_position + Vector3(offset_x, offset_y, offset_z)
