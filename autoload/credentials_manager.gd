extends Node

# Caminho para o arquivo onde as credenciais serão salvas
const CREDENTIALS_PATH = "user://credentials.json"

# Salva as credenciais no arquivo
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

# Carrega as credenciais do arquivo, se existirem
func carregar_credenciais() -> Dictionary:
	var file = FileAccess.open(CREDENTIALS_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var resultado = JSON.parse_string(json_string)
		file.close()
		if resultado:
			return resultado
	return {} # Retorna um dicionário vazio se não houver credenciais

# Verifica se as credenciais salvas existem
func existe_credenciais_salvas() -> bool:
	return FileAccess.file_exists(CREDENTIALS_PATH)

# Remove as credenciais salvas (logout)
func remover_credenciais() -> void:
	if existe_credenciais_salvas():
		var dir = DirAccess.open("user://")  # Abra o diretório atual (ou onde está o arquivo)
		if dir:
			dir.remove(CREDENTIALS_PATH)  # Remove o arquivo
			dir.close()  # Fecha o diretório
