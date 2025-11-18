extends Node2D

@onready var music = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	music.play()
	EventBus.stop_music()


func _on_timer_timeout():
	EventBus.max_out_flow()
