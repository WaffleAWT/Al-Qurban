extends Node3D

#Data
var current_enemy_count : int
var boss_phase : bool = false

#Refrences
@export var gibs_label : Label
@export var bones_label : Label
@export var hole : Node3D
@export var player : CharacterBody3D
@export var ammo_counter : Label
@export var healthbar : ProgressBar
@export var waves : Array[PackedScene]
@export var wave_spawn_timer : Timer
@onready var boss_story = preload("res://Scenes/Levels/boss_story.tscn")
@onready var tree = preload("res://Assets/Models/Prefabs/World/Tree.glb")
@export var trees : Node3D

func _ready() -> void:
	for i in trees.get_children():
		var new_tree = tree.instantiate()
		get_tree().current_scene.add_child(new_tree)
		new_tree.global_position = i.global_position

func _process(_delta : float) -> void:
	gibs_label.text = str(hole.gibs)
	bones_label.text = str(hole.bones)
	if player.weapons_manager.current_weapon.ammo != -1:
		ammo_counter.position = Vector2(239, 0)
		ammo_counter.scale = Vector2(0.125, 0.125)
		ammo_counter.text = str(player.weapons_manager.current_weapon.ammo)
	else:
		ammo_counter.position = Vector2(198, -9)
		ammo_counter.scale = Vector2(0.25, 0.25)
		ammo_counter.text = "∞"
	
	healthbar.value = player.health
	
	current_enemy_count = get_tree().get_nodes_in_group("enemy").size()
	
	if boss_phase:
		get_tree().change_scene_to_packed(boss_story)

func spawn():
	if current_enemy_count < 7:
		for spawner in get_children():
			if spawner is EnemySpawner:
				var random_number : int = randi_range(0, 1)
				if random_number > 0:
					spawner.spawn()

func _on_hole_hole_full() -> void:
	boss_phase = true
