class_name Player extends CharacterBody2D

@onready var anim_player = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var walk_sound := $WalkSound
@export var speed: int = 80
@export var input_enabled: bool = true
@export var direction = Vector2.ZERO
@export var nome: String
@export var pos_player: Vector2
@export var current_mission: String 
@export var current_scene: String
@export var invi: Inv = preload("res://inventory/player_inv.tres")
var is_moving = false
var last_direction = Vector2.DOWN
var charac = Character.new()
var savgm = SaveGame.new()
const EMOTE_SCENE = preload("res://scenes/animations/emotion_anim.tscn")
var emot = EmotionAnim.new()
var device: String
var save_timer: Timer
var quests_pool
var missoes

func _ready():
	nome = ConfigGeral.get_name_player()
	ManagerSave.connect("save_game_request", Callable(self, "save_player_data"))
	sprite.texture = LojinhaManager.current_skin

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

	# print("Invi (SAVE): ", invi)
	# print("Slots no inventário (SAVE): ", invi.slots)
func save_player_data():
	var scene_path_name = get_tree().current_scene.scene_file_path
	var missions = QuestsAt.save_quests()
	savgm.save_game(ConfigGeral.nome_player, self, ConfigGeral.username, invi, scene_path_name, missions)

func load_player_data():
	if not ManagerSave.game_loaded and invi != null:
		savgm.load_game(nome, self, invi)
		ManagerSave.game_loaded = true

func get_save_data() -> Dictionary:
	return {
		"player": nome,
		"inventory_items": invi,
		"mission": current_mission,
		"device": device,
		"missions": {},
		"current_scene": get_tree().current_scene.name,
		 "position": position
		}

func load_save_data(data: Dictionary) -> void:
	nome = data.get("player", "")
	invi = data.get("inventory_items", [])
	device = data.get("device", "")
	missoes = data.get("missions", {})
	current_scene = data.get("current_scene", "")
	position = data.get("position", Vector2())

func disable():
	input_enabled = false
	visible = false

func in_dialogue():
	input_enabled = false
	if !has_node("../DialogBalloon"):
		input_enabled = true

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
	if Input.is_action_pressed("run"):
		load_player_data()
	in_dialogue()
	#walking()

func walking():
	walk_sound.pitch_scale = randf_range(0.9, 1.1)
	walk_sound.play()

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

func balloon_anim(time = 2.0, offset_x = 0.0, offset_y = 0.0) -> EmotionAnim:
	var instance = EMOTE_SCENE.instantiate()
	add_child(instance)
	instance.destroy(time)
	instance.global_position = Vector2(global_position.x + offset_x, global_position.y + offset_y)
	return instance

func anim_exclama(time = 2.0):
	var instance = balloon_anim(time, 11.0, -21.0)
	instance.play_exclama()

func anim_feliz(time = 2.0):
	var instance = balloon_anim(time, 11.0, -21.0)
	instance.play_feliz()

func anim_reticen(time = 2.0):
	var instance = balloon_anim(time, 11.0, -21.0)
	instance.play_reticen()

func anim_interr(time = 2.0):
	var instance = balloon_anim(time, 11.0, -21.0)
	instance.play_interr()
