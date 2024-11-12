extends Node

signal quests_loaded

const QUEST_PATH: String = "res://quests/missions/%s.tres"

func start_quest(quest_name: String) -> void:
	var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_name)
	if quest == null: return
	QuestSystem.start_quest(quest)

func complete_quest(quest_name: String) -> void:
	var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_name)
	if quest == null: return
	QuestSystem.complete_quest(quest)

func view_quests_completed() -> Array:
	var completeds = QuestSystem.quests_as_dict()
	if completeds.has("completed"):
		return completeds.get("completed", "")
	return []

func view_quests_active() -> Array:
	var actives = QuestSystem.quests_as_dict()
	if actives.has("active"):
		return actives.get("active", "")
	return []

func view_quests_availables() -> Array:
	var availables = QuestSystem.quests_as_dict()
	if availables.has("availables"):
		return availables.get("availables", "")
	return []

# Salvar o progresso das quests
func save_quests() -> Dictionary:
	var quest_data = {
		"active": [],
		"completed": [],
		"available": []
	}
	# Coletar nomes das quests ativas usando o método get_active_quests
	for quest in QuestSystem.get_active_quests():
		quest_data["active"].append(quest.nome)  # Supondo que 'quest' tenha uma propriedade 'name'
	# Coletar nomes das quests completadas usando o método get_completed_quests
	for quest in QuestSystem.get_completed_quests(): 
		quest_data["completed"].append(quest.nome)  # Novamente, assumindo que 'quest' tenha uma propriedade 'name'
	for quest in QuestSystem.get_available_quests():
		quest_data["available"].append(quest.nome)  # Novamente, assumindo que 'quest' tenha uma propriedade
	# Aqui você salva 'quest_data' no seu sistema de salvamento
	print(quest_data)
	return quest_data

# Carregar as quests em progresso
func load_quests(quest_data: Dictionary) -> void:
	# Carregar quests ativas
	if quest_data.has("missions_active"):
		for quest_nome in quest_data["missions_active"]:
			var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_nome)
			if quest != null:
				QuestSystem.start_quest(quest)
			else:
				print("Erro: Quest não encontrada com nome: ", quest_nome)
	# Carregar quests completadas
	if quest_data.has("missions_completed"):
		for quest_nome in quest_data["missions_completed"]:
			var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_nome)
			if quest != null:
				QuestSystem.start_quest(quest)
				QuestSystem.complete_quest(quest)
	# Carregar quests disponíveis (se aplicável)
	if quest_data.has("missions_available"):
		for quest_nome in quest_data["missions_available"]:
			var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_nome)
			if quest != null:
				QuestSystem.mark_quest_as_available(quest) # Aqui você pode adicionar a quest como disponível
			else:
				print("Erro: Quest não encontrada com nome: ", quest_nome)
	emit_signal("quests_loaded")

func update_quest(quest_name: String) -> void:
	var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_name)
	if quest == null: return
	QuestSystem.update_quest(quest)

func is_quest_completed(quest_name: String) -> bool:
	var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_name)
	QuestSystem.get_pool("completed")
	if quest == null: return false
	return QuestSystem.is_quest_completed(quest)

func is_quest_available(quest_name: Quest) -> bool:
	var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_name)
	if quest == null: return false
	return QuestSystem.is_quest_available(quest)

func is_quest_active(quest_name: String) -> bool: # Salvar no mission
	var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_name)
	if quest == null: return false
	return QuestSystem.is_quest_active(quest)
	
func get_quest_property(id: int, quest_property: String) -> Variant:
	return QuestSystem.get_quest_property(id, quest_property)
