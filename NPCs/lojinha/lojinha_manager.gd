extends Node

var money: int = 20
var current_skin_id: int = 0  # ID da skin atual
var current_skin: Texture  # Variável para armazenar a textura da skin
var skins: Array = [true, true, true, true, false, false, false]  # Status de compra das skins
var skins_texts := {  # Dicionário de texturas, agora carregando texturas corretamente
	0: preload("res://assets/perso-02.png"),
	1: preload("res://assets/perso-r-roxo.png"),
	2: preload("res://assets/perso-r-verde.png"),
	3: preload("res://assets/perso-r-vermelho.png"),
	4: preload("res://assets/jesus-0.1.png"),
	5: preload("res://assets/samurai-0.1.png"),
	6: preload("res://assets/ET-0.1.png"),
}

# Função chamada quando o nó é carregado
func _ready():
	# Carrega a textura da skin atual com base no ID
	current_skin = skins_texts[current_skin_id]

# Função para salvar as skins
func save_skins():
	# Chame a função de salvar, você pode implementar a lógica de salvar conforme necessário
	ManagerSave.save_by_manager()

func ganhar_moedas(received: int):
	money += received

# Função para verificar se a lojinha está na cena e exibi-la
func ver_lojinha():
	if get_node("/root/LevelLojinha/LojinhaApm") != null:
		var player = get_tree().get_first_node_in_group("players")
		var lojinha = get_node("/root/LevelLojinha/LojinhaApm")
		lojinha.visible = true
	else:
		print("LOJINHAAPM NÃO ESTÁ NA CENA")

# Função para retornar a textura da skin atual
func get_current_skin_texture() -> Texture:
	# Retorna a textura da skin com base no ID atual, se o ID for válido
	if skins_texts.has(current_skin_id):
		return skins_texts[current_skin_id]
	return skins_texts[0]

# Função para verificar a disponibilidade e custo para comprar a skin
func purchase_skin(skin_id: int) -> void:
	if skin_id >= 0 and skin_id < skins.size():
		if skins[skin_id] == false:  # Se a skin não foi comprada ainda
			if money >= 3:
				skins[skin_id] = true  # Marca a skin como comprada
				money -= 3  # Subtrai o valor da skin
				# save_skins()  # Salva as mudanças
				print("Skin %s comprada!" % skin_id)
			else:
				print("Dinheiro insuficiente para comprar a skin %s!" % skin_id)
		else:  # Se a skin já foi comprada, apenas troca a skin
			current_skin_id = skin_id
			current_skin = skins_texts[current_skin_id]
			# save_skins()  # Salva as mudanças
			print("Skin %s selecionada!" % skin_id)
