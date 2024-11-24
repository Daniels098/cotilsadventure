class_name SalaAmarela extends Quest

@export var nome = "sala_amarela"
@export var local_visitado: int = 1
var item: int = 0

func start(_args: Dictionary = {}) -> void:
	item = 0
	local_visitado = 1

func update(_args: Dictionary = {}) -> void:
	if ItemManager.is_visited(nome):
		item = 1
		objective_completed = true
		updated.emit()

func complete(_args: Dictionary = {}) -> void:
	objective_completed = true
	completed.emit()
