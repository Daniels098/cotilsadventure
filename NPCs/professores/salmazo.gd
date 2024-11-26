extends CharacterBody2D

@export var nome: String
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String
const baloon = preload("res://dialogue/balloon.tscn")

func _on_area_2d_body_entered(player: Player):
	if not player is Player:
		return
	if QuestsAt.is_quest_completed("cecom") and QuestsAt.is_quest_completed("cantina"):
		dialogue_start = "salmazo3"
	if QuestsAt.is_quest_active("cecom"):
		dialogue_start = "salmazo2"
	elif QuestsAt.is_quest_active("cantina"):
		dialogue_start = "salmazo3"
	action()
	player.anim_interr()

func action() -> void:
	var ballon: Node = baloon.instantiate()
	get_tree().current_scene.add_child(ballon)
	ballon.start(dialogue_resource, dialogue_start)
