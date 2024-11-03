class_name NPC extends CharacterBody2D

@export var nome: String
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String
const baloon = preload("res://dialogue/balloon.tscn")

func _on_area_2d_body_entered(player: Player):
	if not player is Player:
		return
	action()
	player.anim_interr()

func action() -> void:
	var ballon: Node = baloon.instantiate()
	get_tree().current_scene.add_child(ballon)
	ballon.start(dialogue_resource, dialogue_start)
