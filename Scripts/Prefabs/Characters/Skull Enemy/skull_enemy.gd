extends CharacterBody3D

#Data
@export_category("Data")
@export_group("Stats")
@export var max_health : float = 250.0
@onready var health : float = max_health

@export_group("Sight")
@export var sight_angle : float = 45.0
@export var attack_distance : float = 10.0

@export_group("Movement")
@export var max_speed : float = 10.0
@export var acceleration : float = 25.0
@export var friction : float = 25.0

enum STATES {IDLE, CHASE}
var current_state

var player
@onready var original_y_position : float = position.y

#Refrences
@export_category("Refrences")
@export var timer : Timer
@export var fireball : PackedScene
@export var bone : PackedScene
@export var blood_splatter : PackedScene

func _ready() -> void:
	set_state_idle()
	timer.timeout.connect(attack)

func set_state_idle() -> void:
	current_state = STATES.IDLE

func set_state_chase() -> void:
	current_state = STATES.CHASE

func _physics_process(delta : float) -> void:
	match current_state:
		STATES.IDLE:
			physics_process_idle(delta)
		STATES.CHASE:
			physics_process_chase(delta)
	
	move_and_slide()
	
	if player and velocity != Vector3.ZERO:
		look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
	elif player:
		look_at(player.global_position)

func physics_process_idle(_delta_time : float) -> void:
	if player:
		set_state_chase()

func physics_process_chase(delta_time : float) -> void:
	var direction = (player.global_position - global_position).normalized()
	direction.y = 0
	
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player < attack_distance:
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta_time)
		if timer.is_stopped():
			timer.start()
	else:
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta_time)
	
	global_transform.origin.y = original_y_position

func attack() -> void:
	var fireball_instance = fireball.instantiate()
	get_tree().current_scene.add_child(fireball_instance)
	fireball_instance.set_bodies_to_exclude([self])
	fireball_instance.global_position = $FireballSpawnMarker.global_position
	fireball_instance.set_target_position(player.global_position)

func _on_player_detection_zone_body_entered(body : Node3D) -> void:
	if body.is_in_group("player"):
		player = body

func hurt(damage : float, _direction : Vector3):
	health -= damage
	if health <= 0.0:
		die()
	$AnimationPlayer.play("hit")

func die() -> void:
	AudioManager.play_sound(AudioManager.enemy_death)
	var bone_instance = bone.instantiate()
	var random_number : int = randi_range(1, 2)
	get_tree().current_scene.add_child(bone_instance)
	bone_instance.global_position = global_position
	if random_number > 1:
		var bone_instance_second = bone.instantiate()
		get_tree().current_scene.add_child(bone_instance_second)
		bone_instance_second.global_position = global_position
		bone_instance_second.global_position.x += 1
	var blood_splatter_instance = blood_splatter.instantiate()
	get_tree().current_scene.add_child(blood_splatter_instance)
	blood_splatter_instance.global_position = global_position
	queue_free()
