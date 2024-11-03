extends Node

const QUEST_PATH: String = "res://quests/missions/%s.tres"

func start_quest(quest_name: String) -> void:
	var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_name)
	if quest == null: return
	QuestSystem.start_quest(quest)

func complete_quest(quest_name: String) -> void:
	var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_name)
	if quest == null: return
	QuestSystem.complete_quest(quest)

func get_completed_quests(): # Fazer o método para retornar o dicionário das quests na pool
	return QuestSystem.get_completed_quests() # Retorna um Array com Quests
	# -------- PAREI DAQUI --------
	# Tenho que terminar tratar o array para salvar apenas o nome e o valor se ta completed ou nn (sempre vai tá)

func update_quest(quest_name: String) -> void:
	var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_name)
	if quest == null: return
	QuestSystem.update_quest(quest)

func is_quest_completed(quest_name: String) -> bool: # Fazer um for e salvar no ngcinho
	var quest: Quest = ResourceLoader.load(QUEST_PATH % quest_name)
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
