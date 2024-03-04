extends Node3D

#Data
@export var flash_time : float = 0.05
var timer : Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = flash_time
	timer.timeout.connect(end_flash)

func flash() -> void:
	timer.start()
	rotation.x = randf_range(0.0, 2 * PI)
	show()

func end_flash() -> void:
	hide()
