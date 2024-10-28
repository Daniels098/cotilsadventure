extends Node

signal data_receive
var url = "https://api-cotilsadventuredb.onrender.com/"
@onready var http_request: HTTPRequest = HTTPRequest.new()
var json_string

func _ready():
	if not http_request.is_inside_tree():
		add_child(http_request)
	http_request.request_completed.connect(_on_http_request_completed)

func send_data_game(data):
	var jso = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	http_request.request(url + "updateData/", headers, HTTPClient.METHOD_PUT, jso)

func send_request_game():
	var headers = ["Content-Type: application/json"]
	http_request.request(url + "get_player_data/",headers,HTTPClient.METHOD_GET)

func send_request_register(data):
	var jso = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	http_request.request(url + "register/", headers, HTTPClient.METHOD_POST, jso)

func send_request_login(data):
	var jso = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	http_request.request(url + "login/", headers, HTTPClient.METHOD_POST, jso)

func _on_http_request_completed(result, response_code, headers, body):
	json_string = JSON.parse_string(body.get_string_from_utf8())
	print("Código de retorno da API: ", response_code)
	print("SINAL SENDO ENVIADO")
	emit_signal("data_receive")

func mostra_json():
	return json_string
