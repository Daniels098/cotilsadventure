extends RefCounted
class_name DAO

var db

func _init():
	db = SQLite.new()
	db.path = "user://data.db"
	db.open_db()
	
	var table = {
		"id": {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"usuario": {"data_type": "text", "not_null": true, "unique": true},
		"nome": {"data_type": "text", "not_null": true, },
		"email": {"data_type": "text", "not_null": true, "unique": true},
		"senha": {"data_type": "text", "not_null": true,},
		"progresso": {"data_type": "blob", "not_null": true, },
	}
	
	db.create_table("jog_cotils_adventure", table)
	print("TabelaCriada")

func insertUserData(usuario, nome, email, senha):
	var data = {
		"usuario": usuario,
		"nome": nome,
		"email": email,
		"senha": senha,
	}
	db.insert_row("jog_cotils_adventure", data)

func getUserData(usuario):
	var query = db.query("SELECT * FROM jog_cotils_adventure where usuario = '"+ usuario +"'")
	
	for i in db.query_result:
		return {
			"id": i["id"],
			"usuario": usuario,
			"nome": i["nome"],
			"email": i["email"],
			"hashedPass": i["password"],
		}
