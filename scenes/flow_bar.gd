extends CanvasLayer

@onready var progress_bar = $ProgressBar
@onready var label = $Label
@onready var hurt = $hurt
@onready var anims = $AnimationPlayer
@export var max_out_flow: bool = false
@export var level_timer : int = 225
@onready var timer: Label = $Control/Label2
@export var disable_timer: bool = false
@onready var timer_node: Timer = $Timer
@onready var timer_card: Sprite2D = $Sprite2D

func _ready():
	if disable_timer:
		timer_node.stop()
		timer_card.hide()
		timer.hide()
	timer.text = str(level_timer)
	EventBus.flow_up.connect(change_flow)
	EventBus.flow_down.connect(just_hurt)
	if max_out_flow:
		EventBus.max_out_flow()
		change_flow()

func change_flow():
	progress_bar.value = EventBus.current_flow
	if progress_bar.value >= 10:
		label.show()

func just_hurt():
	progress_bar.value = EventBus.current_flow
	hurt.play()
	anims.play('hurt')
	if progress_bar.value < 10:
		label.hide()

func _on_timer_timeout() -> void:
	if disable_timer:
		return
	level_timer -= 1
	if level_timer <= 25:
		var tween = create_tween()
		tween.tween_property(timer, 'modulate', Color(1,0,0), 0.1)
		tween.tween_property(timer, 'modulate', Color(1,1,1), 0.1)
	timer.text = str(level_timer)
	if level_timer <= 0:
		EventBus.reset_level.emit()
	
