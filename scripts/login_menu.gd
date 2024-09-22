extends Control

var username = ""
var password
var email
var rePassword
var nome
var dao = DAO.new()

var created = false

func toggle_register_login():
	if $ToggleRegisterLogin.text == "Ja possui uma conta?":
		#Register
		$UsernameRe.visible = false
		$NomeRe.visible = false
		$EmailRe.visible = false
		$PasswordRe.visible = false
		$RePasswordRe.visible = false
		$Registrar.visible = false
		#Login
		$Entrar.visible = true
		$UsernameLo.visible = true
		$PasswordLo.visible = true
		$ToggleRegisterLogin.text = "Nao possui uma conta?"
		$Titulo.text = "Entre na sua conta agora!"
	elif $ToggleRegisterLogin.text == "Nao possui uma conta?":
		#Register
		$UsernameRe.visible = true
		$NomeRe.visible = true
		$EmailRe.visible = true
		$PasswordRe.visible = true
		$RePasswordRe.visible = true
		$Registrar.visible = true
		#Login
		$Entrar.visible = false
		$UsernameLo.visible = false
		$PasswordLo.visible = false
		#Buttons
		$ToggleRegisterLogin.text = "Ja possui uma conta?"
		$Titulo.text = "Salve seu progresso criando uma conta!"

func _on_toggle_register_login_button_down():
	toggle_register_login()
	$Aviso.visible = false
	$Aviso2.visible = false

func _on_registrar_button_down():
	$Aviso.visible = false
	if !created:
		$Aviso2.visible = true
		password = $PasswordRe.text
		rePassword = $RePasswordRe.text
		if password == rePassword:
			$Aviso.visible = false
			username = $UsernameRe.text
			nome = $NomeRe.text
			email = $EmailRe.text
			password = $PasswordRe.text.sha256_text()
			created = true
			$UsernameRe.text = ""
			$NomeRe.text = ""
			$EmailRe.text = ""
			$PasswordRe.text = ""
			$RePasswordRe.text = ""
			toggle_register_login()
		else:
			$Aviso.visible = true
	if created:
		$Aviso2.visible = false
	
	dao.insertUserData(username, nome, email, password)
	print("inserido")

func _on_voltar_button_down():
	SceneManager.load_new_scene("res://scenes/menu/menu.tscn")

func _on_entrar_button_down():
	print("entrado")
