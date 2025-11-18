extends Node2D

@onready var bgm = $BGM
@onready var record_scratches = $RecordScratches
@onready var animation_player = $Node2D/AnimationPlayer
@onready var credits = $Credits

func _input(event):
	if event.is_action_pressed('start') and not credits.visible:
		start_game()
	if event.is_action_pressed('credits'):
		show_credits()

func show_credits():
	credits.visible = !credits.visible

func start_game():
	bgm.stop()
	record_scratches.play()
	
func _on_bgm_finished():
	bgm.play()

func _on_record_scratches_finished():
	animation_player.play('jump_up')

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'jump_up':
		EventBus.emit_next_level()
