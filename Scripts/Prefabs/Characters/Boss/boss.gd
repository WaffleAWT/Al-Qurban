extends CharacterBody3D

#Data
@export_category("Data")
@export_group("Movement")
@export var max_speed : float = 15.0
@export var acceleration : float = 20.0
@export var friction : float = 20.0

@export_group("Stats")
@export var max_health : float = 500.0
@onready var health : float = max_health
var can_attack : bool = true
var rotated_attack : bool = false

enum {IDLE, CHASE, ATTACK, JUMP}
var state

const LERP_VALUE : float = 0.30

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_scalar_factor : float = 3.0

#Refrences
@export_category("Refrences")
@export var navigation : NavigationAgent3D
@export var animator : AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("player")
@export var blood_splatter : PackedScene
@export var damage_area : Area3D

func _ready() -> void:
	damage_area.bodies_to_exclude.append(self)
	state = IDLE
	get_tree().create_timer(3.0).timeout.connect(set_state_chase)

func set_state_chase() -> void:
	state = CHASE

func _physics_process(delta : float) -> void:
	apply_gravity(delta)
	
	match state:
		IDLE:
			idle(delta)
		CHASE:
			chase(delta)
		ATTACK:
			attack(delta)
		JUMP:
			jump(delta)
	
	move_and_slide()

func idle(delta_time : float) -> void:
	animator.speed_scale = 1.0
	animator.play("Idle")
	
	velocity = velocity.move_toward(Vector3.ZERO, friction * delta_time)

func chase(delta_time : float) -> void:
	animator.speed_scale = 1.0
	animator.play("Run")
	
	var direction = Vector3()
	if is_instance_valid(navigation):
		navigation.target_position = player.global_position
		direction = navigation.get_next_path_position() - global_position
		direction = direction.normalized()
	
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta_time)
	if player and velocity != Vector3.ZERO:
		look_at(Vector3(global_position.x + -velocity.x, global_position.y, global_position.z + -velocity.z), Vector3.UP)
	elif player:
		look_at(player.global_position)
	
	var distance_to_player = global_position.distance_squared_to(player.global_position)
	if distance_to_player <= 50 and health > max_health/2:
		state = ATTACK
	elif distance_to_player >= 100 and health <= max_health/2:
		state = JUMP
	elif distance_to_player <= 50 and health <= max_health/2:
		state = ATTACK

func attack(delta_time : float) -> void:
	if not rotated_attack:
		rotation.y += 0.5
		rotated_attack = true
	velocity = velocity.move_toward(Vector3.ZERO, friction * delta_time)
	animator.speed_scale = 1.5
	var random_number : int = randi_range(1, 3)
	if random_number > 2 and can_attack:
		animator.play("Attack")
		get_tree().create_timer(3.2).timeout.connect(set_can_attack)
		can_attack = false
	elif can_attack:
		get_tree().create_timer(3.2).timeout.connect(set_can_attack)
		animator.play("Attack")
		can_attack = false

func set_can_attack() -> void:
	can_attack = true
	rotated_attack = false
	state = CHASE

func jump(delta_time : float) -> void:
	animator.speed_scale = 1.0
	animator.play("Jump")
	get_tree().create_timer(4).timeout.connect(set_chase)
	
	var direction = Vector3()
	if is_instance_valid(navigation):
		navigation.target_position = player.global_position
		direction = navigation.get_next_path_position() - global_position
		direction = direction.normalized()
	
	velocity = velocity.move_toward(direction * (max_speed * 3), acceleration * delta_time)
	if player and velocity != Vector3.ZERO:
		look_at(Vector3(global_position.x + -velocity.x, global_position.y, global_position.z + -velocity.z), Vector3.UP)
	elif player:
		look_at(player.global_position)

func set_chase() -> void:
	state = CHASE

func hurt(damage : float, _direction : Vector3) -> void:
	if state == IDLE:
		state = CHASE
	
	health -= damage
	if health <= 0.0:
		die()
	$HitAnimator.play("hit")

func play_sound() -> void:
	var random_number : int = randi_range(1, 2)
	if random_number == 1:
		$AudioStreamPlayer3D.playing = true

func die() -> void:
	AudioManager.play_sound(AudioManager.enemy_death)
	var blood_splatter_instance = blood_splatter.instantiate()
	get_tree().current_scene.add_child(blood_splatter_instance)
	blood_splatter_instance.global_position = global_position
	blood_splatter_instance.position.y += 2.0
	var blood_splatter_instance_2 = blood_splatter.instantiate()
	get_tree().current_scene.add_child(blood_splatter_instance_2)
	blood_splatter_instance_2.global_position = global_position
	blood_splatter_instance_2.position.y -= 2.0
	var blood_splatter_instance_3 = blood_splatter.instantiate()
	get_tree().current_scene.add_child(blood_splatter_instance_3)
	blood_splatter_instance_3.global_position = global_position
	blood_splatter_instance_3.position.x += 2.0
	var blood_splatter_instance_4 = blood_splatter.instantiate()
	get_tree().current_scene.add_child(blood_splatter_instance_4)
	blood_splatter_instance_4.global_position = global_position
	blood_splatter_instance_4.position.x -= 2.0
	FrameFreeze.frame_freeze(0.05, 5.0)
	queue_free()

func apply_gravity(delta_time : float):
	if not is_on_floor():
		if velocity.y > 0.0:
			velocity.y -= gravity * delta_time
		else:
			velocity.y -= (gravity * delta_time) * gravity_scalar_factor

func _on_damage_jump_body_entered(body : Node3D) -> void:
	if body.is_in_group("player") and state == JUMP:
		body.hurt(100.0, global_transform.origin.direction_to(body.global_transform.origin))
