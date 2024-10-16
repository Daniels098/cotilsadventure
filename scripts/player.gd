class_name Player extends CharacterBody2D

@export var speed: int = 80
@export var input_enabled: bool = true
@export var direction = Vector2.ZERO
@onready var anim_player = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D 
@export var nome: String
@export var pos_player: Vector2
@export var current_mission: String 
@export var current_scene: String
@export var invi: Inv = preload("res://inventory/player_inv.tres")
var is_moving = false
var last_direction = Vector2.DOWN
var charac = Character.new()
var savgm = SaveGame.new()

func orient(input_direct: Vector2) -> void:
	if anim_player != null:
		if input_direct.x > 0:
			anim_player.play("Right")
			sprite.flip_h = true
		elif input_direct.x < 0:
			anim_player.play("Left")
			sprite.flip_h = false
		elif input_direct.y > 0:
			anim_player.play("Down")
		elif input_direct.y < 0:
			anim_player.play("Up")

func collect(item: InvItem):
	invi.insert(item)

func save_player_data():
	var scene_path_name = get_tree().current_scene.scene_file_path
	var mission = "Missão atual" # Salvar ID da missão
	savgm.save_game(self, invi, scene_path_name, mission)

func load_player_data():
	var scene_path_name = get_tree().current_scene.scene_file_path
	var data = savgm.load_game(nome, self, invi)
	var scene_name = data["scene"]
	if scene_name != scene_path_name:
		print("INVENTAAAARIOOOO PELO LOAD PLAYER DATA")
		print(data["inventory"])
		SceneManager.load_new_scene(scene_name)
	else:
		#print(data)
		print("Já está na cena")


func get_save_data() -> Dictionary:
	return {
		"inventory_items": invi,
		"mission": current_mission,
		"current_scene": get_tree().current_scene.name,
		 "position": position
		}

func load_save_data(data: Dictionary) -> void:
	invi = data.get("inventory_items", [])
	current_mission = data.get("mission", "")
	current_scene = data.get("current_scene", "")
	position = data.get("position", Vector2())

func disable():
	input_enabled = false
	visible = false

func enable():
	input_enabled = true
	visible = true
	anim_player.play("Down")

func entered_door():
	emit_signal("player_entered_door")

func _physics_process(delta):
	if input_enabled:
		direction = Vector2.ZERO
		is_moving = false
		if Input.is_action_pressed("move_right"):
			direction.x = 1
			is_moving = true
		elif Input.is_action_pressed("move_left"):
			direction.x = -1
			is_moving = true
		elif Input.is_action_pressed("move_down"):
			direction.y = 1
			is_moving = true
		elif Input.is_action_pressed("move_up"):
			direction.y = -1
			is_moving = true
		if direction != Vector2.ZERO:
			direction = direction.normalized()
			velocity = direction * speed
			move_and_slide()
			move(direction)
			last_direction = direction
		else:
			move(direction)
			idle_animation()
	if Input.is_action_just_pressed("interact"):
		save_player_data()
	if Input.is_action_just_pressed("run"):
		load_player_data()                

func move(input_direct: Vector2):
	if input_direct.x > 0:
		anim_player.play("WalkRight")
		sprite.flip_h = true
	elif input_direct.x < 0:
		anim_player.play("WalkLeft")
		sprite.flip_h = false
	elif input_direct.y > 0:
		anim_player.play("WalkDown")
	elif input_direct.y < 0:
		anim_player.play("WalkUp")

func idle_animation():
	if last_direction == Vector2.DOWN:
		anim_player.play("Down")
	elif last_direction == Vector2.UP:
		anim_player.play("Up")
	elif last_direction == Vector2.LEFT:
		anim_player.play("Left")
	elif last_direction == Vector2.RIGHT:
		anim_player.play("Right")
