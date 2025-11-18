extends Node2D

var current_flow: int = 0
var old_flow : int = 0
var flow_level: int = 0:
	set(new):
		if flow_level != new:
			flow_level = new
			new_track.emit()

signal flow_up
signal flow_down
signal switch_to_new_level
signal new_track

@onready var bgm_controller = $BGMController

func change_music(music_file: AudioStreamWAV):
	if not bgm_controller.is_queued_for_deletion():
		bgm_controller.audio_stream_player_2d.stream = music_file
		bgm_controller.audio_stream_player_2d.play()

func check_flow():
	var set_flow = 0
	if current_flow == 10:
		set_flow = 2
	if current_flow < 10:
		set_flow = 1
	if current_flow < 5:
		set_flow = 0
	flow_level = set_flow

func increase_flow():
	old_flow = current_flow
	if old_flow >= 10:
		current_flow = 10
	else:
		current_flow += 1
	check_flow()
	flow_up.emit()
		
func decrease_flow():
	old_flow = current_flow
	if old_flow <= 0:
		current_flow = 0
	else:
		current_flow -= 1
	check_flow()
	flow_down.emit()

func emit_next_level():
	switch_to_new_level.emit()
	clear_flow()
	
func clear_flow():
	current_flow = 0
	flow_level = 0
	old_flow = 0
	check_flow()

func max_out_flow():
	current_flow = 10
	old_flow = 9
	flow_level = 2
	check_flow()
	flow_up.emit()

func stop_music():
	bgm_controller.queue_free()
