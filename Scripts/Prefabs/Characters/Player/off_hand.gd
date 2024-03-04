extends Node3D

#Data
enum ITEM {EMPTY, GIB, BONE}
var current_item

#Refrences
@export var animator : AnimationPlayer

func _ready() -> void:
	current_item = ITEM.EMPTY

func _process(_delta : float) -> void:
	match current_item:
		ITEM.EMPTY:
			$Gib.hide()
			$Bone.hide()
		ITEM.GIB:
			$Gib.show()
			$Bone.hide()
		ITEM.BONE:
			$Gib.hide()
			$Bone.show()

func eat():
	match current_item:
		ITEM.GIB:
			owner.health += 100
			if owner.health > owner.max_health:
				owner.health = owner.max_health
			current_item = ITEM.EMPTY
		ITEM.BONE:
			for weapon in owner.weapons_manager.weapons:
				if weapon.ammo >= 0:
					match weapon.name:
						"BaseballBat":
							pass
						"Shotgun":
							weapon.ammo += 15
						"Rifle":
							weapon.ammo += 30
						"Bazooka":
							weapon.ammo += 6
			current_item = ITEM.EMPTY
