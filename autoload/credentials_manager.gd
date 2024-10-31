extends Node

const CREDENTIALS_PATH = "user://credentials.json"

func salvar_credenciais(username: String, nome: String, password: String) -> void:
	var credenciais = {
		"username": username,
		"name": nome,
		"password": password
	}
	var file = FileAccess.open(CREDENTIALS_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(credenciais))
		file.close()

func carregar_credenciais() -> Dictionary:
	var file = FileAccess.open(CREDENTIALS_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var resultado = JSON.parse_string(json_string)
		file.close()
		if resultado:
			return resultado
	return {} # Retorna um dicionário vazio se não houver credenciais

func existe_credenciais_salvas() -> bool:
	return FileAccess.file_exists(CREDENTIALS_PATH)

func remover_credenciais() -> void:
	if existe_credenciais_salvas():
		var dir = DirAccess.open("user://")  # Abra o diretório atual (ou onde está o arquivo)
		if dir:
			dir.remove(CREDENTIALS_PATH)  # Remove o arquivo
			dir.close()  # Fecha o diretório

