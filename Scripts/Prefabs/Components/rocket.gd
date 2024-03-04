extends CharacterBody3D

#Data
@export var speed : float = 20.0
var impact_damage : float = 20.0
var exploded : bool = false

#Refrences
@export var explosion : PackedScene

func _ready() -> void:
	hide()

func set_bodies_to_exclude(bodies_to_exclude : Array) -> void:
	for body in bodies_to_exclude:
		add_collision_exception_with(body)

func _physics_process(delta : float) -> void:
	var collision : KinematicCollision3D = move_and_collide(-global_transform.basis.z * speed * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.has_method("hurt"):
			collider.hurt(impact_damage, -global_transform.basis.z)
		explode()

func explode() -> void:
	if exploded:
		return
	exploded = true
	speed = 0
	$CollisionShape3D.disabled = true
	var explosion_instance = explosion.instantiate()
	get_tree().current_scene.add_child(explosion_instance)
	explosion_instance.global_transform.origin = global_transform.origin
	explosion_instance.explode()
	$Graphics/SmokeTrail.emitting = false
	$Graphics.hide()
	$DestroyAfterTimeTimer.start()
