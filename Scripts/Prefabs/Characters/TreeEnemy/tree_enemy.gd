extends CharacterBody3D

#Data
const ANIMATION_BLEND : float = 7.0

@export_category("Data")
@export_group("Stats")
@export var max_health : float = 500.0
@onready var health : float = max_health

@export_group("Sight")
@export var sight_angle : float = 45.0

@export_group("Movement")
@export var max_speed : float = 5.0
@export var acceleration : float = 10.0
@export var friction : float = 10.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_scalar_factor : float = 3.0

enum STATES {IDLE, CHASE, ATTACK}
var current_state

var can_attack : bool = true

var player

#Refrences
@export_category("Refrences")
@export var animator : AnimationPlayer
@export var navigation : NavigationAgent3D
@export var damage_area : Area3D
@export var gib : PackedScene
@export var blood_splatter : PackedScene

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	var bone_attachments = $Graphics/TreeGuy/Armature/Skeleton3D.get_children()
	for bone_attachment in bone_attachments:
		for child in bone_attachment.get_children():
			if child is Hitbox:
				child.hurt_hitbox.connect(hurt)
	
	damage_area.bodies_to_exclude.append(self)
	set_state_idle()

func _physics_process(delta : float) -> void:
	apply_gravity(delta)
	match current_state:
		STATES.IDLE:
			physics_process_idle(delta)
		STATES.CHASE:
			physics_process_chase(delta)
		STATES.ATTACK:
			physics_process_attack(delta)
	
	move_and_slide()

func hurt(damage : float, _direction : Vector3) -> void:
	if current_state == STATES.IDLE:
		set_state_chase()
	
	health -= damage
	if health <= 0.0:
		die()
	$HitAnimator.play("hit")

func die() -> void:
	AudioManager.play_sound(AudioManager.enemy_death)
	var gib_instance = gib.instantiate()
	var random_number : int = randi_range(1, 2)
	get_tree().current_scene.add_child(gib_instance)
	gib_instance.global_position = global_position
	gib_instance.global_position.y = 0.4
	if random_number > 1:
		var gib_instance_second = gib.instantiate()
		get_tree().current_scene.add_child(gib_instance_second)
		gib_instance_second.global_position = global_position
		gib_instance_second.global_position.y = 0.4
		gib_instance_second.global_position.x += 1
	var blood_splatter_instance = blood_splatter.instantiate()
	get_tree().current_scene.add_child(blood_splatter_instance)
	blood_splatter_instance.global_position = global_position
	blood_splatter_instance.position.y += 2.0
	queue_free()

func set_state_idle() -> void:
	current_state = STATES.IDLE

func set_state_chase() -> void:
	current_state = STATES.CHASE
	if is_instance_valid(animator):
		animator.play("Run")

func set_state_attack() -> void:
	current_state = STATES.ATTACK

func physics_process_idle(_delta_time : float) -> void:
	#if can_see_player():
		#set_state_chase()
	set_state_chase()

func physics_process_chase(delta_time : float) -> void:
	var direction = Vector3()
	if is_instance_valid(navigation):
		navigation.target_position = player.global_position
		direction = navigation.get_next_path_position() - global_position
		direction = direction.normalized()
	
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta_time)
	if player and velocity != Vector3.ZERO:
		look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
	elif player:
		look_at(player.global_position)
	
	var distance_to_player = global_position.distance_squared_to(player.global_position)
	if distance_to_player >= 2.5:
		set_state_attack()

func physics_process_attack(_delta_time : float) -> void:
	var random_number : int = randi_range(1, 3)
	if random_number > 2 and can_attack:
		animator.play("Attack")
		get_tree().create_timer(2.7).timeout.connect(set_can_attack)
		can_attack = false
	elif can_attack:
		get_tree().create_timer(1.1333).timeout.connect(set_can_attack)
		animator.play("Attack2")
		can_attack = false
	
	var distance_to_player = global_position.distance_squared_to(player.global_position)
	if distance_to_player > 3.5:
		set_state_chase()
	
	move_and_slide()

func set_can_attack() -> void:
	can_attack = true

func apply_gravity(delta_time : float) -> void:
	if not is_on_floor():
		if velocity.y > 0.0:
			velocity.y -= gravity * delta_time
		else:
			velocity.y -= (gravity * delta_time) * gravity_scalar_factor

func can_see_player():
	var direction_to_player = global_transform.origin.direction_to(player.global_transform.origin)
	var forwards = global_transform.basis.z
	return rad_to_deg(forwards.angle_to(-direction_to_player)) < sight_angle and has_los_player()

func has_los_player() -> bool:
	var our_position = global_transform.origin + Vector3.UP
	var player_position = player.global_transform.origin + Vector3.UP
	
	var space_state = get_world_3d().direct_space_state
	var physics_query = PhysicsRayQueryParameters3D.create(our_position, player_position, 1)
	physics_query.exclude = []
	var result = space_state.intersect_ray(physics_query)
	if result:
		return false
	return true

func alert(check_los = true) -> void:
	if current_state != STATES.IDLE:
		return
	if check_los and !has_los_player():
		return
	set_state_chase()
