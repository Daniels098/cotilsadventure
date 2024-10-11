extends Node2D

@export var item: InvItem

func _on_area_2d_body_entered(player: Player):
	if not player is Player:
		return
	var collected = item
	player.collect(collected)
	queue_free()
