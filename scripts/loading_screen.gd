class_name LoadingScreen extends CanvasLayer

signal transition_in_complete

@onready var progress_bar: ProgressBar = %Control/ProgressBar
@onready var timer: Timer = $Timer
@onready var anim_player: AnimationPlayer = $AnimationPlayer
var starting_animation_name: String

func _ready() -> void:
	#progress_bar.visible = false
	pass
	

func start_transition(animation_name:String) -> void:
	if !anim_player.has_animation(animation_name):
		push_warning("'%s' animation does not exist" % animation_name)
		animation_name = "fade_to_black"
	starting_animation_name = animation_name
	anim_player.play(animation_name)
	timer.start()

func finish_transition() -> void:
	if timer:
		timer.stop()
	
	var ending_animation_name:String = starting_animation_name.replace("to","from")
	
	if !anim_player.has_animation(ending_animation_name):
		push_warning("'%s' animation dos not exit" % ending_animation_name)
		ending_animation_name = "fade_from_black"
	anim_player.play(ending_animation_name)
	
	await anim_player.animation_finished
	queue_free()

func _on_timer_timeout() -> void:
	progress_bar.visible = true

func report_midpoint() -> void:
	transition_in_complete.emit()
