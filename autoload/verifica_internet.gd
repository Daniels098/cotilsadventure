extends Node

@onready var http_request: HTTPRequest = HTTPRequest.new()

signal internet_available(available: bool)

var test_url = "https://www.google.com/"

func _ready():
	if not http_request.is_inside_tree():
		add_child(http_request)
	# Conecta o sinal de requisição completada
	http_request.request_completed.connect(_on_request_completed)

func is_internet_available() -> void:
	var headers = ["Content-Type: application/json"]
	var status = http_request.request(test_url, headers, HTTPClient.METHOD_GET)
	if status == OK:
		print("Requisição HTTP enviada para verificação.")
	else:
		emit_signal("internet_available", false)

# Callback quando a requisição for completada
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Conexão com a internet estabelecida.")
		emit_signal("internet_available", true)
	else:
		print("Falha na conexão com a internet. Código de resposta: ", response_code)
		emit_signal("internet_available", false)
