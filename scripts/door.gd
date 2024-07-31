class_name Door extends Area2D

signal player_entered_door(door:Door)

@export var path_to_new_scene:String
@export var entry_door_name:String

func _on_body_entered(body) -> void:
	if not body is Player:
		return
	player_entered_door.emit(self)
	SceneManager.load_new_scene(path_to_new_scene)
	queue_free()
