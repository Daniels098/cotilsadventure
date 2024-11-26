extends CharacterBody2D

@export var nome: String
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String
const baloon = preload("res://dialogue/balloon.tscn")

func _on_area_2d_body_entered(player: Player):
	if not player is Player:
		return
	if QuestsAt.is_quest_active("sala_vermelha"):
		dialogue_start = "verinha1"
	if QuestsAt.is_quest_active("sala_verde"):
		dialogue_start = "verinha2"
	if QuestsAt.is_quest_active("sala_amarela"):
		dialogue_start = "verinha3"
	if QuestsAt.is_quest_active("sala_azul"):
		dialogue_start = "verinha4"
	player.anim_interr()
	action()

func action() -> void:
	var ballon: Node = baloon.instantiate()
	get_tree().current_scene.add_child(ballon)
	ballon.start(dialogue_resource, dialogue_start)
