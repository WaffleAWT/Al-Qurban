extends Area3D

#Data
@export var speed : float = 10.0
@export var speed_scalar : float = 2.0
@export var impact_damage : float = 20.0
var exploded : bool = false
var bodies_to_exclude : Array = []
var target_position : Vector3 = Vector3.ZERO

#Refrences
@export var explosion : PackedScene

#func _ready() -> void:
	#get_tree().create_timer(3.0).timeout.connect(explode)

func set_bodies_to_exclude(_bodies_to_exclude : Array) -> void:
	for body in _bodies_to_exclude:
		bodies_to_exclude.append(body)

func set_target_position(target : Vector3) -> void:
	target_position = target

func _physics_process(delta : float) -> void:
	for skull in get_tree().get_nodes_in_group("skull"):
		bodies_to_exclude.append(skull)
	
	var direction = (target_position - global_transform.origin).normalized()
	global_transform.origin += direction * speed * speed_scalar * delta
	if global_transform.origin.distance_to(target_position) < 0.2:
		explode()

func explode() -> void:
	if exploded:
		return
	exploded = true
	speed = 0
	$CollisionShape3D.set_deferred("disabled", true)
	var explosion_instance = explosion.instantiate()
	get_tree().current_scene.add_child(explosion_instance)
	explosion_instance.global_transform.origin = global_transform.origin
	explosion_instance.explode()
	$GPUParticles3D.hide()
	$OmniLight3D.hide()
	$DestroyAfterTimeTimer.start()

func _on_body_entered(body : Node3D) -> void:
	if bodies_to_exclude.count(body) == 0:
		if body.is_in_group("player"):
			body.hurt(impact_damage, -global_transform.basis.z)
		explode()
