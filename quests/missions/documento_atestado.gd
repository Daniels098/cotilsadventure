class_name DocumentoAtestado extends Quest

@export var atestado_necessario: int = 1
@export var nome = "atestado"
var item: int = 0

func start(_args: Dictionary = {}) -> void:
	item = 0
	atestado_necessario = 1

func update(_args: Dictionary = {}) -> void:
	if item < atestado_necessario:
		item = 1
		objective_completed = true
		updated.emit()

func complete(_args: Dictionary = {}) -> void:
	objective_completed = true
	completed.emit()
