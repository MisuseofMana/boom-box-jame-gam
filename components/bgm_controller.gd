extends Node2D

@export var audio_loop: AudioStreamWAV
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_stream_player_2d.stream = audio_loop

func _on_audio_stream_player_2d_finished():
	audio_stream_player_2d.play()
