class_name QuestCompleted extends CompletedQuestPool


func add_quest(quest:Quest) -> Quest:
	if QuestSystem.is_quest_in_pool(quest, "available"):
		print("slaoq", quest)
	return quest
