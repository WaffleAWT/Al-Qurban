extends CharacterBody3D

#Signals
signal add_gib
signal add_bone

#Data
@export_category("Data")
@export_group("Movement Data")
@export var max_speed : float = 10.0
@export var acceleration : float = 0.2
@export var deceleration : float = 0.5
@export var jump_strength : float = 9.0

@export_group("Camera Data")
@export var mouse_sensitivity : float = 0.5
@export var tilt_lower_limit := deg_to_rad(-90.0)
@export var tilt_upper_limit := deg_to_rad(90.0)

var mouse_input : bool = false
var rotation_input : float
var tilt_input : float
var mouse_rotation : Vector3
var player_rotation : Vector3
var camera_rotation : Vector3

@export_group("Stats")
@export var max_health : float
@onready var health : float = max_health - 25
@export var can_move : bool = true

#Input
var hotkeys : Dictionary = {
	KEY_1 : 49,
	KEY_2 : 50,
	KEY_3 : 51,
	KEY_4 : 52,
	KEY_5 : 53,
	KEY_6 : 54,
	KEY_7 : 55,
	KEY_8 : 56,
	KEY_9 : 57,
	KEY_0 : 48
}

#Refrences
@export_category("Refrences")
@export var camera_controller : Camera3D
@export var weapons_manager : Node3D
@export var off_hand : Node3D
@export var sight : RayCast3D
@export var pickup_label : Label
@export var crosshairs : Array[Control]

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_scalar_factor : float = 3.0

func _unhandled_input(event : InputEvent) -> void:
	if can_move:
		mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
		if mouse_input:
			rotation_input = -event.relative.x * mouse_sensitivity
			tilt_input = -event.relative.y * mouse_sensitivity

func update_camera(delta) -> void:
	if can_move:
		mouse_rotation.x += tilt_input * delta
		mouse_rotation.x = clamp(mouse_rotation.x, tilt_lower_limit, tilt_upper_limit)
		mouse_rotation.y += rotation_input * delta
		
		player_rotation = Vector3(0.0,mouse_rotation.y,0.0)
		camera_rotation = Vector3(mouse_rotation.x,0.0,0.0)
		
		camera_controller.transform.basis = Basis.from_euler(camera_rotation)
		global_transform.basis = Basis.from_euler(player_rotation)
		
		camera_controller.rotation.z = 0.0
		
		rotation_input = 0.0
		tilt_input = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	weapons_manager.init($CameraController/Camera3D/FirePoint, [self])

func _process(_delta : float) -> void:
	weapons_manager.attack(Input.is_action_just_pressed("attack"), Input.is_action_pressed("attack"))

func _physics_process(delta : float) -> void:
	update_camera(delta)
	apply_gravity(delta)
	
	if can_move:
		if get_direction():
			velocity.x = lerp(velocity.x, get_direction().x * max_speed, acceleration)
			velocity.z = lerp(velocity.z, get_direction().z * max_speed, acceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, deceleration)
			velocity.z = move_toward(velocity.z, 0, deceleration)
		
		move_and_slide()
	
	if sight.is_colliding():
		var target = sight.get_collider()
		if target:
			if target.is_in_group("bone") and off_hand.current_item == off_hand.ITEM.EMPTY:
				pickup_label.text = "حمل العظام (E)"
				$UI.visible = true
			if target.is_in_group("gib") and off_hand.current_item == off_hand.ITEM.EMPTY:
				pickup_label.text = "حمل اللحم (E)"
				$UI.visible = true
			if target.is_in_group("hole") and !off_hand.current_item == off_hand.ITEM.EMPTY:
				match off_hand.current_item:
					off_hand.ITEM.GIB:
						pickup_label.text = "غرس اللحم (E)"
						$UI.visible = true
					off_hand.ITEM.BONE:
						pickup_label.text = "غرز العظم (E)"
						$UI.visible = true
	else:
		$UI.visible = false

func _input(event : InputEvent) -> void:
	if can_move:
		if event is InputEventKey:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				jump()
	
	if event is InputEventKey and event.is_pressed():
		if event.keycode in hotkeys:
			match_event(event.keycode)
		
		if Input.is_action_just_pressed("action") and sight.is_colliding():
			var target = sight.get_collider()
			if target.is_in_group("gib") or target.is_in_group("bone"):
				target.pick()
			if target.is_in_group("hole"):
				if off_hand.current_item == off_hand.ITEM.GIB:
							add_gib.emit()
							$UI.visible = false
				if off_hand.current_item == off_hand.ITEM.BONE:
							add_bone.emit()
							$UI.visible = false
				off_hand.current_item = off_hand.ITEM.EMPTY
	
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			weapons_manager.switch_to_next_weapon()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			weapons_manager.switch_to_last_weapon()
		if Input.is_action_just_pressed("eat"):
			off_hand.animator.play("eat")

func apply_gravity(delta_time : float) -> void:
	if not is_on_floor():
		if velocity.y > 0.0:
			velocity.y -= gravity * delta_time
		else:
			velocity.y -= (gravity * delta_time) * gravity_scalar_factor

func get_direction() -> Vector3:
	var input_direction = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction = (transform.basis * Vector3(input_direction.x, 0.0, input_direction.y)).normalized()
	return direction

func jump() -> void:
	velocity.y = jump_strength

func hurt(damage : float, direction : Vector3) -> void:
	health -= damage
	if health <= 0.0:
		die()
	velocity += direction.normalized() * 5.0

func die():
	pass

func match_event(key_code) -> void:
	if can_move:
		match key_code:
					48:
						weapons_manager.switch_to_weapon_slot(9)
					49:
						weapons_manager.switch_to_weapon_slot(0)
					50:
						weapons_manager.switch_to_weapon_slot(1)
					51:
						weapons_manager.switch_to_weapon_slot(2)
					52:
						weapons_manager.switch_to_weapon_slot(3)
					53:
						weapons_manager.switch_to_weapon_slot(4)
					54:
						weapons_manager.switch_to_weapon_slot(5)
					55:
						weapons_manager.switch_to_weapon_slot(6)
					56:
						weapons_manager.switch_to_weapon_slot(7)
					57:
						weapons_manager.switch_to_weapon_slot(8)
