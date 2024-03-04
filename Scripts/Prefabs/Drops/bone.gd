extends Area3D

#Refrences
@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(delta : float) -> void:
	if get_overlapping_bodies().size() == 0:
		position.y -= 3.5 * delta

func pick() -> void:
	if player.off_hand.current_item == player.off_hand.ITEM.EMPTY:
		player.off_hand.current_item = player.off_hand.ITEM.BONE
		queue_free()
