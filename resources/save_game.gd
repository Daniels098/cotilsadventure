extends Node
class_name SaveGame

const SAVE_PATH = "user://save_game.json"
var data = {}
var jso := JSON.new()
var invi := Inv.new()

# Função para salvar os dados do jogador localmente e/ou na API
func save_game(nome: String, player: Player, user: String, invi: Inv, scene_name: String, missions: Dictionary) -> void:
	var save_data = {
		"nome": nome,
		"scene": scene_name,
		"username": user,
		"missions": {
			"missions_available": missions.get("available"),
			"missions_active": missions.get("active"),
			"missions_completed": missions.get("completed")
		},
		"device": OS.get_name(),
		"inventory": [],
		"position": {
			"x": player.position.x,
			"y": player.position.y
		},
		"collected_items": ItemManager.collected_items,
		"skins": LojinhaManager.skins,
		"moedas": LojinhaManager.money,
		"current_skin": LojinhaManager.current_skin_id,
	}
	
	# Preencher o inventário
	if invi != null and invi.slots.size() > 0:
		for slot in invi.slots:
			if slot.item:
				save_data["inventory"].append({
					"amount": slot.amount,
					"item_name": slot.item.nome
				})
	
	# Salvar localmente no arquivo JSON
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(jso.stringify(save_data, "\t"))
		file.close()
		print("Jogo salvo localmente.")
		# HttpsRequest.send_data_game(save_data)
		# Salvar na nuvem somente se estiver conectado
		#if await HttpsRequest.is_internet_available():
		#	print("Jogo salvo na nuvem com sucesso!")
		#else:
	else:
		print("Falha ao salvar o jogo localmente!")

# Função para carregar os dados do jogador
func load_game(name: String, player: Player, invi: Inv) -> Dictionary:
	# Carregar dados da nuvem se conectado à internet
	#if await HttpsRequest.is_internet_available():
	"""var cloud_data = HttpsRequest.load_cloud_save(credentials.get("username"))
	if cloud_data != null:
		name = cloud_data.get("player", name)
		if cloud_data.has("scene") and cloud_data["scene"] != null:
			player.current_scene = cloud_data["scene"]
		player.device = OS.get_name()
		
		var position_data = cloud_data.get("position", null)
		if position_data and (position_data.get("x", 0) != 0 or position_data.get("y", 0) != 0):
			player.position.x = position_data["x"]
			player.position.y = position_data["y"]
		
		# Carregar o inventário da nuvem
		var saved_inventory = cloud_data.get("inventory", [])
		invi.populate_all_items()
		for slot in invi.slots:
			slot.item = null
			slot.amount = 0
		
		for i in range(min(saved_inventory.size(), invi.slots.size())):
			var item_data = saved_inventory[i]
			var item = invi.get_item_by_name(item_data.get("item_name", ""))
			if item:
				invi.slots[i].item = item
				invi.slots[i].amount = item_data.get("amount", 0)

		# Carregar as missões da nuvem
		if cloud_data.has("missions"):
			QuestsAt.load_quests(cloud_data["missions"])
		
		for quest in QuestsAt.view_quests_active():
			quest.update()
		
		# Carregar os itens coletados da nuvem
		if cloud_data.has("collected_items"):
			ItemManager.collected_items = cloud_data["collected_items"]
		
		# Carregar as skins
		if cloud_data.has("skins") and typeof(cloud_data["skins"]) == TYPE_ARRAY:
			LojinhaManager.skins = cloud_data["skins"]
		
		print("Jogo carregado da nuvem com sucesso!")
		return cloud_data
	else:
		print("Erro ao carregar da nuvem, carregando localmente...")"""
	
	# Carregar localmente
	var credentials = CredentialsManager.carregar_credenciais()
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var error = jso.parse(json_string)
		if error == OK:
			var data = jso.data
			if typeof(data) == TYPE_DICTIONARY:
				player.current_scene = data["scene"]
				player.position.x = data["position"]["x"]
				player.position.y = data["position"]["y"]
				player.device = OS.get_name()
				
				# Carregar o inventário
				var saved_inventory = data["inventory"]
				invi.populate_all_items()
				for slot in invi.slots:
					slot.item = null
					slot.amount = 0
				for i in range(min(saved_inventory.size(), invi.slots.size())):
					var item_data = saved_inventory[i]
					var item = invi.get_item_by_name(item_data["item_name"])
					if item:
						invi.slots[i].item = item
						invi.slots[i].amount = item_data["amount"]

				# Carregar as missões
				if data.has("missions"):
					QuestsAt.load_quests(data["missions"])

				# Carregar os itens coletados
				if data.has("collected_items"):
					ItemManager.collected_items = data["collected_items"]

				# Carregar as skins
				if data.has("skins"):
					LojinhaManager.skins = data["skins"]
				if data.has("current_skin"):
					LojinhaManager.current_skin_id = data["current_skin"]
					player.sprite.texture = LojinhaManager.get_current_skin_texture()

				# Carregar o dinheiro
				if data.has("moedas"):
					LojinhaManager.money = data["moedas"]

				file.close()
				print("Jogo carregado com sucesso!")
				return data
			else:
				print("'Data' não é um Dictionary, dados inválidos no arquivo de save.")
				return {}
		else:
			print("Erro ao carregar JSON: ", jso.get_error_message())
			return {}
	print("Nenhum save encontrado!")
	return {}
