extends Control


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/corredor_terreo_academico.tscn")

func _on_button_4_pressed():
	get_tree().quit()


func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
