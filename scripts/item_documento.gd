extends Node2D

@export var item: InvItem
var jog = Player.new()

func _on_area_2d_body_entered(body):
	if not body is Player:
		return
	jog.collect(item)
	queue_free()
