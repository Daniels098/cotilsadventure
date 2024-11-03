class_name DocumentosMatricula extends Quest

@export var documento_necessario: int = 1
var documento: int = 0

func start(_args: Dictionary = {}) -> void:
	documento = 0
	documento_necessario = 1

func update(_args: Dictionary = {}) -> void:
	if documento < documento_necessario:
		documento = 1
		objective_completed = true
		updated.emit()

func complete(_args: Dictionary = {}) -> void:
	pass
