class_name MedicoAtestado extends Quest

@export var medico_atestado: int = 1
@export var nome = "medico"
var item: int = 0

func start(_args: Dictionary = {}) -> void:
	item = 0
	medico_atestado = 1

func update(_args: Dictionary = {}) -> void:
	if item < medico_atestado:
		item = 1
		objective_completed = true
		updated.emit()

func complete(_args: Dictionary = {}) -> void:
	objective_completed = true
	completed.emit()
