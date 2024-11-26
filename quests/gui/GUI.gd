extends CanvasLayer

var _active_quests: Array = []  # Lista de missões ativas (até 3)
@onready var menu = $Panel
@onready var mission = $Mission
@onready var moedas = $Mission/Moedas

# Referências para a missão atual e para as três posições do menu de missões
@onready var quest_ui = [
	{"name": $%CurrentQuest2, "description": $%Description, "progress": $%Progress2, "objective": $%Objective},
	{"name": $%CurrentQuest3, "description": $%Description1, "progress": $%Progress3, "objective": $%Objective1},
	{"name": $%CurrentQuest4, "description": $%Description2, "progress": $%Progress4, "objective": $%Objective2}
]

@onready var mission_current_name = $%CurrentQuest  # Missão atual no canto
@onready var mission_current_progress = $%Progress

func _ready() -> void:
	moedas.visible = true
	menu.visible = false
	QuestSystem.quest_accepted.connect(add_quest)
	QuestSystem.quest_completed.connect(complete_quest)
	QuestsAt.connect("quests_loaded", Callable(self, "load_active_quests"))
	
	# Inicializa a interface para ocultar missões e mostrar a missão atual
	reset_ui()
	update_current_mission()

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		menu.visible = !menu.visible
		mission.visible = !menu.visible

func _process(_delta: float) -> void:
	update_current_mission()
	update_menu_missions()
	moedas.text = "Moedas: %s" % str(LojinhaManager.money)

func add_quest(quest: Quest) -> void:
	# Adiciona uma nova missão, limitando o máximo a 3 ativas
	if QuestManager._active_quests.size() < 3:
		QuestManager._active_quests.append(quest)
	update_current_mission()

func complete_quest(quest: Quest) -> void:
	# Remove a missão concluída e atualiza a interface
	QuestManager._active_quests.erase(quest)
	update_current_mission()

func update_current_mission() -> void:
	# Atualiza a missão atual no canto da tela
	if QuestManager._active_quests.size() > 0:
		var current_quest = QuestManager._active_quests[0]
		current_quest.update()  # Atualiza o progresso da missão

		mission_current_name.text = "Missão Atual: %s" % current_quest.quest_name
		mission_current_progress.text = "Em progresso: %s/1" % current_quest.item
		mission_current_name.show()
		mission_current_progress.show()
	else:
		mission_current_name.hide()
		mission_current_progress.hide()


func update_menu_missions() -> void:
	# Atualiza o menu com as informações de todas as missões ativas
	for i in range(QuestManager._active_quests.size()):
		var quest = QuestManager._active_quests[i]
		quest.update()  # Atualiza o progresso da missão com base no inventário

		quest_ui[i]["name"].text = "Missão: %s" % quest.quest_name
		quest_ui[i]["description"].text = "Descrição: %s" % quest.quest_description
		quest_ui[i]["objective"].text = "Objetivo: %s" % quest.quest_objective
		quest_ui[i]["progress"].text = "Progresso: %s/1" % quest.item

		# Exibe cada campo da missão
		quest_ui[i]["name"].show()
		quest_ui[i]["description"].show()
		quest_ui[i]["objective"].show()
		quest_ui[i]["progress"].show()

	# Esconde espaços de missões vazios se houver menos de 3 missões
	for j in range(QuestManager._active_quests.size(), quest_ui.size()):
		quest_ui[j]["name"].hide()
		quest_ui[j]["description"].hide()
		quest_ui[j]["objective"].hide()
		quest_ui[j]["progress"].hide()


func reset_ui() -> void:
	# Esconde todos os elementos da UI das missões ao iniciar
	for element in quest_ui:
		element["name"].hide()
		element["description"].hide()
		element["objective"].hide()
		element["progress"].hide()
	mission_current_name.hide()
	mission_current_progress.hide()

func _on_volta_button_pressed():
	menu.visible = !menu.visible
	mission.visible = !menu.visible
