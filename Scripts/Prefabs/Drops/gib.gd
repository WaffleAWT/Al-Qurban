extends Area3D

#Refrences
@onready var player = get_tree().get_first_node_in_group("player")

func pick():
	if player.off_hand.current_item == player.off_hand.ITEM.EMPTY:
		player.off_hand.current_item = player.off_hand.ITEM.GIB
		queue_free()
