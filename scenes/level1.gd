extends Node2D

const FIRST = preload("uid://w0sq6gxo870n")
const SECOND = preload("uid://cemibwhpraqbe")
const THIRD = preload("uid://bdyua8iyyit0i")

var music_files : Array[AudioStreamWAV] = [FIRST, SECOND, THIRD]

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.new_track.connect(next_track)
	EventBus.change_music(music_files[0])

func next_track():
	EventBus.change_music(music_files[EventBus.flow_level])
