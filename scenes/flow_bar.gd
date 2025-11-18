extends CanvasLayer

@onready var progress_bar = $ProgressBar
@onready var label = $Label
@onready var hurt = $hurt
@onready var anims = $AnimationPlayer
@export var max_out_flow: bool = false

func _ready():
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
