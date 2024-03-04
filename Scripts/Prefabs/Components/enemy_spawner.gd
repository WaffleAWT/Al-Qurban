extends Node3D
class_name EnemySpawner

#Refrences
@export var tree_enemy : PackedScene
@export var skull_enemy : PackedScene

func spawn() -> void:
	var random_enemy_number_picker : int = randi_range(1, 2)
	match random_enemy_number_picker:
		1:
			spawn_tree_enemy()
		2:
			spawn_skull_enemy()

func spawn_tree_enemy() -> void:
	var random_number : int = randi_range(1, 2)
	var enemy = tree_enemy.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = global_position
	if random_number > 1:
		var enemy_2 = tree_enemy.instantiate()
		get_tree().current_scene.add_child(enemy_2)
		enemy_2.global_position = global_position
		enemy_2.position.x += 1

func spawn_skull_enemy() -> void:
	var random_number : int = randi_range(1, 3)
	var enemy = skull_enemy.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = global_position
	enemy.position.y += 1
	if random_number == 2:
		var enemy_2 = skull_enemy.instantiate()
		get_tree().current_scene.add_child(enemy_2)
		enemy_2.global_position = global_position
		enemy_2.position.x += 1
		enemy_2.position.y += 1
	if random_number > 2:
		var enemy_3 = skull_enemy.instantiate()
		get_tree().current_scene.add_child(enemy_3)
		enemy_3.global_position = global_position
		enemy_3.position.x -= 1
		enemy_3.position.y += 1
