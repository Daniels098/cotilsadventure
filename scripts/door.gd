class_name Door extends Area2D

signal player_entered_door(door:Door,transition_type:String)

@export_enum("norte","leste","sul","oeste") var entry_direction
@export_enum("fade_to_black","fade_to_white","wipe_to_right","zelda") var transition_type:String
@export var push_distance:int = 16
@export var path_to_new_scene:String
@export var entry_door_name:String
@export var enable:bool = false
@onready var timer = $Timer

func _ready():
	timer.start(1.0)
	enable = false

func _on_timer_timeout():
	enable = true

func _on_body_entered(player: Node) -> void:
	if enable:
		if not player is Player:
			return
		player_entered_door.emit(self)
		if transition_type == "zelda":
			SceneManager.load_level_zelda(path_to_new_scene)
		else:
			SceneManager.load_new_scene(path_to_new_scene,transition_type)
		queue_free()
	else:
		return

func get_player_entry_vector() -> Vector2:
	var vector:Vector2 = Vector2.LEFT
	match entry_direction:
		0:
			vector = Vector2.UP
		1: 
			vector = Vector2.RIGHT
		2:
			vector = Vector2.DOWN
	return (vector * push_distance) + self.position

func get_move_dir() -> Vector2:
	var dir:Vector2 = Vector2.RIGHT
	match entry_direction:
		0:
			dir = Vector2.DOWN
		1: 
			dir = Vector2.LEFT
		2:
			dir = Vector2.UP	
	return dir
