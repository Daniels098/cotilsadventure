extends Node

signal data_receive
var url = "https://api-mongodb-seven.vercel.app/"
@onready var http_request: HTTPRequest = HTTPRequest.new()
var json_string
var is_connected = false

func _ready():
	if not http_request.is_inside_tree():
		add_child(http_request)
	http_request.request_completed.connect(_on_http_request_completed)

# Função para verificar a disponibilidade da internet
func is_internet_available() -> bool:
	var headers = ["Content-Type: application/json"]
	# Inicia uma requisição GET para testar a conexão
	var status = http_request.request(url, headers, HTTPClient.METHOD_GET)
	if status == OK:
		# Usa await para esperar a requisição ser completada
		await http_request.request_completed
		return is_connected  # Retorna se a requisição foi bem-sucedida ou não
	return false

func send_data_game(data):
	var jso = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	http_request.request(url + "updateData/", headers, HTTPClient.METHOD_PUT, jso)

func send_request_game(username: String):
	var headers = ["Content-Type: application/json"]
	http_request.request(url + "get_player_data/" + username, headers, HTTPClient.METHOD_GET)

func send_request_register(data):
	var jso = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	http_request.request(url + "register/", headers, HTTPClient.METHOD_POST, jso)

func send_request_login(data):
	var jso = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	http_request.request(url + "login/", headers, HTTPClient.METHOD_POST, jso)

func load_cloud_save(username: String):
	if username == "":
		print("Nome de usuário não fornecido.")
		return
	var headers = ["Content-Type: application/json"]
	http_request.request(url + "get_player_data/" + username, headers, HTTPClient.METHOD_GET)

# Função chamada quando a requisição HTTP é completada
func _on_http_request_completed(result, response_code, headers, body):
	# Verifica se a requisição foi bem-sucedida (status 200)
	if response_code == 200:
		is_connected = true
	else:
		is_connected = false
		
	json_string = JSON.parse_string(body.get_string_from_utf8())
	print("Corpo da resposta:", body.get_string_from_utf8())
	print("Código de retorno da API: ", response_code)
	print("RESULT: ", result)
	
	emit_signal("data_receive")

func mostra_json():
	return json_string
