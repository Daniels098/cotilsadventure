class_name Character extends Node

@export var player: Player

func get_character_data() -> Dictionary:
	if player:
		return player.get_save_data()
	return {}

func load_character_data(data: Dictionary) -> void:
	if player:
		player.load_save_data(data)
