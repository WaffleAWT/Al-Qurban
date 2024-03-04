extends Area3D

#Data
@export var pickup_weapon : String

func _ready() -> void:
	match pickup_weapon:
		"Rifle":
			$Rifle.visible = true
		"Bazooka":
			$Bazooka.visible = true

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		match pickup_weapon:
			"Rifle":
				body.weapons_manager.slots_unlocked[body.weapons_manager.WEAPON_SLOTS.RIFLE] = true
				var weapons = body.weapons_manager.weapons
				for weapon in weapons:
					if weapon.ammo >= 0:
						match weapon.name:
							"Rifle":
								weapon.ammo += 30
							"Bazooka":
								pass
			"Bazooka":
				body.weapons_manager.slots_unlocked[body.weapons_manager.WEAPON_SLOTS.BAZOOKA] = true
				var weapons = body.weapons_manager.weapons
				for weapon in weapons:
					if weapon.ammo >= 0:
						match weapon.name:
							"Rifle":
								pass
							"Bazooka":
								weapon.ammo += 10
		queue_free()
