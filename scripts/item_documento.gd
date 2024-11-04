extends Node2D

@export var item: InvItem
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String
const baloon = preload("res://dialogue/balloon.tscn")

func _on_area_2d_body_entered(player: Player):
	if QuestsAt.is_quest_active("matricula"):
		if not player is Player:
			return
		var collected = item
		player.collect(collected)
		action()
		player.anim_exclama()
		queue_free()
	else:
		action()
	var a = QuestsAt.view_quests_completed()
	print(a)
	a = QuestsAt.view_quests_active()
	print(a)

func action() -> void:
	var ballon: Node = baloon.instantiate()
	get_tree().current_scene.add_child(ballon)
	ballon.start(dialogue_resource, dialogue_start)
	
