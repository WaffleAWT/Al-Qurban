extends Node3D

#Data
var ended : bool = false

#Refrences
@export var boss : CharacterBody3D
@export var player : CharacterBody3D
@export var ammo_counter : Label
@onready var end_scene = preload("res://Scenes/Levels/end_scene.tscn")

func _process(_delta : float) -> void:
	$UI/Healthbar.value = player.health
	if is_instance_valid(boss):
		$UI/BossBar.value = boss.health
	else:
		$UI/BossBar.visible = false
		if $Timer.is_stopped() and not ended:
			$Timer.start()
			ended = true
	
	if player.weapons_manager.current_weapon.ammo != -1:
		ammo_counter.position = Vector2(239, 0)
		ammo_counter.scale = Vector2(0.125, 0.125)
		ammo_counter.text = str(player.weapons_manager.current_weapon.ammo)
	else:
		ammo_counter.position = Vector2(198, -9)
		ammo_counter.scale = Vector2(0.25, 0.25)
		ammo_counter.text = "∞"

func game_won() -> void:
	$AnimationPlayer.play("animate")

func play_swoosh() -> void:
	AudioManager.play_sound(AudioManager.swoosh)

func change_scene() -> void:
	get_tree().change_scene_to_packed(end_scene)
