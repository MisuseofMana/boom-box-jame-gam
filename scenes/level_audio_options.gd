extends Node2D
class_name LevelAudioOptions

@export var music_files : Array[AudioStreamWAV] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.new_track.connect(next_track)
	EventBus.change_music(music_files[0])

func next_track():
	EventBus.change_music(music_files[EventBus.flow_level])
