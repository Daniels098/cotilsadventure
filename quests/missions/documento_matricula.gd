class_name DocumentoMatricula extends Quest

@export var nome = "matricula"
@export var documento_necessario: int = 1
var item: int = 0

func start(_args: Dictionary = {}) -> void:
	item = 0
	documento_necessario = 1

func update(_args: Dictionary = {}) -> void:
	if item < documento_necessario:
		item = 1
		objective_completed = true
		updated.emit()

func complete(_args: Dictionary = {}) -> void:
	objective_completed = true
	completed.emit()
