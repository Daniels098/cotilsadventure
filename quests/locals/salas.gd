extends Node2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String
const baloon = preload("res://dialogue/balloon.tscn")

func _on_area_2d_body_entered(player: Player): # Vermelho, Verde, Amarelo e Azul
	# Caso não queira tudo isso de "if e dialogue_start = a algo", dá pra colocar o nome dentro da cena da sala
	if not player is Player:
		return
	player.anim_exclama()
	if QuestsAt.is_quest_active("sala_vermelha"):
		dialogue_start = "sala_vermelha"
	if QuestsAt.is_quest_active("sala_verde"):
		dialogue_start = "sala_verde"
	if QuestsAt.is_quest_active("sala_amarela"):
		dialogue_start = "sala_amarela"
	if QuestsAt.is_quest_active("sala_azul"):
		dialogue_start = "sala_azul"
	action()

func action() -> void:
	var ballon: Node = baloon.instantiate()
	get_tree().current_scene.add_child(ballon)
	ballon.start(dialogue_resource, dialogue_start)
