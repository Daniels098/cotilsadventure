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
@onready var timer = Timer.new()
@onready var entrar_button = $Entrar
@onready var scene_change_timer = $SceneChangeTimer

func _ready():
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	$Aviso.visible = true
	$Aviso.text = "Aviso: O nome de usuário é único e instransferível"
	#HttpsRequest.connect("data_receive", Callable(self, "_on_data_receive"))
	
	scene_change_timer.wait_time = 2
	scene_change_timer.one_shot = true
	scene_change_timer.connect("timeout", Callable(self, "_on_scene_change_timeout"))

func toggle_register_login():
	if $ToggleRegisterLogin.text == "Ja possui uma conta?":
		#Register Botões
		$NomeRe.visible = false
		$NomeReLabel.visible = false
		$EmailRe.visible = false
		$EmailReLabel.visible = false
		$PasswordRe.visible = false
		$SenhaReLabel.visible = false
		$RePasswordRe.visible = false
		$ReSenhaReLabel.visible = false
		$Registrar.visible = false
		#Login Botões
		$EmailLo.visible = true
		$EmailLoLabel.visible = true
		$Entrar.visible = true
		$PasswordLo.visible = true
		$SenhaLoLabel.visible = true
		$ToggleRegisterLogin.text = "Nao possui uma conta?"
		$Titulo.text = "Entre na sua conta agora!"
	elif $ToggleRegisterLogin.text == "Nao possui uma conta?":
		#Register Botões
		$NomeRe.visible = true
		$NomeReLabel.visible = true
		$EmailRe.visible = true
		$EmailReLabel.visible = true
		$PasswordRe.visible = true
		$SenhaReLabel.visible = true
		$RePasswordRe.visible = true
		$ReSenhaReLabel.visible = true
		$Registrar.visible = true
		#Login Botões
		$EmailLo.visible = false
		$EmailLoLabel.visible = false
		$Entrar.visible = false
		$PasswordLo.visible = false
		$SenhaLoLabel.visible = false
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
			$Aviso.visible = false
			password = $PasswordRe.text
			rePassword = $RePasswordRe.text
			if password == rePassword:
				$Aviso.visible = true
				$Aviso.text = "Conta criada com sucesso!
				Carregando... Espere 3s"
				nome = $NomeRe.text
				username = $EmailRe.text
				# Salvando local
				CredentialsManager.salvar_credenciais(username, nome, password)
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
				# HttpsRequest.send_request_register(data)
				toggle_register_login()
				$PasswordLo.text = password
				$EmailLo.text = username
				bloquear_login_por_tempo(3)
			else:
				$Aviso.visible = true
				$Aviso.text = "As senhas nao coincidem!"
		else:
			$Aviso.visible = true
			$Aviso.text = "Uma conta já foi criada!
			Se você esqueceu sua senha vá ao \'cotils-adventure.vercel.app\' e mude"
	else:
		$Aviso.visible = true
		$Aviso.text = "Preencha todos os campos!"

func _on_voltar_button_down():
	SceneManager.load_new_scene("res://scenes/menu/menu.tscn")

func bloquear_login_por_tempo(segundos: float) -> void:
	entrar_button.disabled = true
	timer.start(segundos)

func _on_timer_timeout():
	$Aviso.text = "Clique em \"Entrar\" para começar a jogar!"
	entrar_button.disabled = false
	$Entrar.grab_focus()

func _on_entrar_button_down():
	username = $EmailLo.text.strip_edges()
	password = $PasswordLo.text.strip_edges()
	
	var credentials = CredentialsManager.carregar_credenciais()
	
	# Validar credenciais salvas
	if credentials.get("username", "") == username and credentials.get("password", "") == password:
		$Aviso.visible = true
		$Aviso.text = "Login efetuado com sucesso! Carregando dados..."
		ConfigGeral.set_name_player(credentials.get("name", ""))
		ConfigGeral.username = username
		carregando_data()
		scene_change_timer.start()
	else:
		$Aviso.visible = true
		$Aviso.text = "Usuário ou senha incorretos!"

func carregando_data():
	$Aviso.visible = true
	$Aviso.text = "Carregando dados locais..."

func _on_data_receive(): ## Tratar o "Username já está em uso"
	print("DATA RECEBIDA")
	# cloud = HttpsRequest.mostra_json() # não ta salvos
	# print(cloud)
	if $Aviso.text == "Carregando dados da nuvem...":
		$Aviso.text = "Login efetuado!"
	
	ConfigGeral.data_cloud = cloud["playerData"]
	ConfigGeral.username = cloud["playerData"]["username"]
	ConfigGeral.set_name_player(cloud["credential"]["name"])
	CredentialsManager.salvar_credenciais(username, cloud["credential"]["name"], password)

func _on_scene_change_timeout():
	SceneManager.load_new_scene("res://scenes/menu/menu.tscn")

# ------------------------- Switch Focus -------------------------
func _on_nome_re_text_submitted(new_text) -> void:
	$EmailRe.grab_focus()

func _on_email_re_text_submitted(new_text) -> void:
	$PasswordRe.grab_focus()

func _on_password_re_text_submitted(new_text) -> void:
	$RePasswordRe.grab_focus()

func _on_re_password_re_text_submitted(new_text) -> void:
	_on_registrar_button_down()

func _on_password_lo_text_submitted(new_text) -> void:
	_on_entrar_button_down()

func _on_email_lo_text_submitted(new_text) -> void:
	$PasswordLo.grab_focus()
