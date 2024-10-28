extends Node2D

@onready var anim_titles = $AnimationPlayer
@onready var godot = $godot_engine
@onready var nomes = $feito_por
@onready var img = $Sprite2D

func _ready():
	# Tenta carregar as credenciais
	var credentials = CredentialsManager.carregar_credenciais()
	if credentials:
		print("Iniciando login automático...")
		automatic_login(credentials)
	else:
		print("Nenhuma credencial salva encontrada.")
	anim_letters()
	terminar_inicio()

func anim_letters() -> void:
	godot.visible = true
	img.visible = true
	anim_titles.play("fade_in_godot")
	await anim_titles.animation_finished
	anim_titles.play("fade_out_godot")
	await anim_titles.animation_finished
	img.visible = false
	godot.visible = false
	nomes.visible = true
	anim_titles.play("fade_in_nomes")
	await anim_titles.animation_finished
	anim_titles.play("fade_out_nomes")
	await anim_titles.animation_finished
	nomes.visible = false

func terminar_inicio() -> void:
	await get_tree().create_timer(7).timeout
	SceneManager.load_new_scene("res://scenes/menu/menu.tscn")

func automatic_login(credentials: Dictionary) -> void:
	var username = credentials.get("username", "")
	var nome = credentials.get("name", "")
	var password = credentials.get("password", "")
	
	if username != "" and nome != "" and password != "":
		print("Login automático com o usuário: ", username, " e nome: ", nome)
		ConfigGeral.set_name_player(nome)
		# Chame o autoload que cuida do login com as credenciais salvas
		var data = {
			"username": username,
			"password": password
		}
		HttpsRequest.send_request_login(data)
	else:
		print("Credenciais salvas estão incompletas. Iniciando animação.")
		anim_letters()
		terminar_inicio()
