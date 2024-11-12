class_name DocumentoMatricula extends Quest

@export var nome = "matricula"
@export var documento_necessario: int = 1
var item: int = 0

var sla_oq

func start(_args: Dictionary = {}) -> void:
	item = 0
	documento_necessario = 1

func update(_args: Dictionary = {}) -> void:
	if item < documento_necessario or QuestManager.check_item_in_inventory("documento"):
		pass # Possivelmente muito errado
		
	if item >= documento_necessario:
		objective_completed = true
		updated.emit()

func complete(_args: Dictionary = {}) -> void:
	objective_completed = true
	completed.emit()

"""func check_for_document(player_inventory: Array) -> void:
	if quest_manager.check_item_in_inventory(player_inventory, "documento"):  # Chama a função do QuestManager
		item = documento_necessario  # Atualiza o progresso da missão
		print("Documento encontrado! Progresso da missão atualizado.")"""
