class_name APM extends CharacterBody2D

@export var dialogue_resource: DialogueResource # Lojinha Diálogo
@export var dialogue_start: String
const baloon = preload("res://dialogue/balloon.tscn")

func _on_lojinha_collisor_body_entered(player: Player):
	if not player is Player:
		return
	action()
	player.anim_exclama()

func action() -> void:
	var ballon: Node = baloon.instantiate()
	get_tree().current_scene.add_child(ballon)
	ballon.start(dialogue_resource, dialogue_start)

