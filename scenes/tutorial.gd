extends Node2D

const DRUM_LOOP = preload("uid://unlhu8ac2iba")
const FLOW_2_TRACK = preload("uid://de3jo0a7d56xi")
const MAX_FLOW = preload("uid://cq6v36cvru5v6")

var music_files : Array[AudioStreamWAV] = [DRUM_LOOP, FLOW_2_TRACK, MAX_FLOW]

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.clear_flow()
	EventBus.new_track.connect(next_track)
	EventBus.change_music(music_files[0])

func next_track():
	EventBus.change_music(music_files[EventBus.flow_level])
