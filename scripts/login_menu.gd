extends Control

var username = ""
var password
var email
var rePassword


var created = false

func _on_button_button_down():
	if !created:
		username = $Username.text
		password = $Password.text.sha256_text()
		rePassword = $RePassword.text.sha256_text()
		if password == rePassword:
			print("OK")
		else:
			print("NOT OK")
		created = true
		$Button.text = "Login"
		$Username.text = ""
		$Password.text = ""
