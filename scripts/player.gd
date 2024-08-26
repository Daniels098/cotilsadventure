class_name Player extends CharacterBody2D

@export_category("Variables")
@export var speed:int = 65
@export var input_enabled:bool = true
@export var direction = Vector2.ZERO
@onready var anim_player = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

func orient(input_direction:Vector2) -> void:
	if input_direction.x:
		sprite.flip_h = input_direction.x < 0

func disable():
	input_enabled = false
	visible = false
	anim_player.play("Down")

func enable():
	input_enabled = true
	visible = true

func entered_door():
	emit_signal("player_entered_door")

func _physics_process(delta):
	if input_enabled:
		direction = Vector2.ZERO
		if Input.is_action_pressed("move_right"): #get_action_strength
			direction.x = 1
		elif Input.is_action_pressed("move_left"):
			direction.x = -1
		elif Input.is_action_pressed("move_down"):
			direction.y = 1
		elif Input.is_action_pressed("move_up"):
			direction.y = -1
		if direction != Vector2.ZERO:
			direction = direction.normalized()
			velocity = direction * speed
			move_and_slide()
			move(delta)

func move(delta):
	if Input.is_anything_pressed():
			if direction.y > 0:
				anim_player.play("WalkDown")
			elif direction.x > 0:
				anim_player.play("WalkRight")
			elif direction.x < 0:
				anim_player.play("WalkLeft")
			elif direction.y < 0:
				anim_player.play("WalkUp")
