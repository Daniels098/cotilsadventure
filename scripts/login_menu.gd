extends Control

var data = {}
var password: String
var username: String
var rePassword: String
var nome: String
var svgm: SaveGame = SaveGame.new()
var created = false
var cloud
@onready var no = $NomeRe
@onready var ema = $EmailRe
@onready var paswd = $PasswordRe
@onready var repaswd = $RePasswordRe

func _ready():
	HttpsRequest.connect("data_receive", Callable(self, "_on_data_receive"))

func toggle_register_login():
	if $ToggleRegisterLogin.text == "Ja possui uma conta?":
		#Register Botões
		$NomeRe.visible = false
		$EmailRe.visible = false
		$PasswordRe.visible = false
		$RePasswordRe.visible = false
		$Registrar.visible = false
		#Login Botões
		$EmailLo.visible = true
		$Entrar.visible = true
		$PasswordLo.visible = true
		$ToggleRegisterLogin.text = "Nao possui uma conta?"
		$Titulo.text = "Entre na sua conta agora!"
	elif $ToggleRegisterLogin.text == "Nao possui uma conta?":
		#Register Botões
		$NomeRe.visible = true
		$EmailRe.visible = true
		$PasswordRe.visible = true
		$RePasswordRe.visible = true
		$Registrar.visible = true
		#Login Botões
		$EmailLo.visible = false
		$Entrar.visible = false
		$PasswordLo.visible = false
		# Botões
		$ToggleRegisterLogin.text = "Ja possui uma conta?"
		$Titulo.text = "Salve seu progresso criando uma conta!"

func _on_toggle_register_login_button_down():
	toggle_register_login()
	$Aviso.visible = false

func is_gmail() -> bool:
	var teste = ema.to_lower().strip_edges()
	if teste.ends_with("@gmail.com"):
		return true
	else:
		return false

func _on_registrar_button_down():
	$Aviso.visible = false
	if no.text.strip_edges() != "" && ema.text.strip_edges() != "" && paswd.text.strip_edges() != "" && repaswd.text.strip_edges() != "":
		if !created:
			$Aviso.visible = true
			password = $PasswordRe.text
			rePassword = $RePasswordRe.text
			if password == rePassword:
				$Aviso.visible = false
				nome = $NomeRe.text
				username = $EmailRe.text
				password = $PasswordRe.text#.sha256_text()
				created = true
				$NomeRe.text = ""
				$EmailRe.text = ""
				$PasswordRe.text = ""
				$RePasswordRe.text = ""
				ConfigGeral.nome_player = nome
				data = {
				"name": nome,
				"username": username,
				"password": password
				}
				print(data)
				HttpsRequest.send_request_register(data)
				toggle_register_login()
			else:
				$Aviso.visible = true
				$Aviso.text = "As senhas nao coincidem!"
		else:
			$Aviso.visible = false
	else:
		$Aviso.visible = true
		$Aviso.text = "Preencha todos os campos!"

func _on_voltar_button_down():
	SceneManager.load_new_scene("res://scenes/menu/menu.tscn")

func _on_entrar_button_down():
	username = $EmailLo.text
	password = $PasswordLo.text
	data = {
		"username": username,
		"password": password
	}
	HttpsRequest.send_request_login(data)
	carregando_data()

func carregando_data():
	$Aviso.visible = true
	$Aviso.text = "Carregando dados da nuvem..."

func _on_data_receive():
	var cloud = HttpsRequest.mostra_json()
	print(cloud)
	$Aviso.text = "Login efetuado!"
	ConfigGeral.data_cloud = cloud["playerData"]
	ConfigGeral.username = cloud["playerData"]["username"]
	ConfigGeral.set_name_player(cloud["credential"]["name"])
	CredentialsManager.salvar_credenciais(username, cloud["credential"]["name"], password)
