extends Node


export var bpm := 120
export var measures := 4


var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1
var closest = 0
var time_off_beat = 0.0
var duration = 2.0
var max_volume = 0.0
var mute_volume = -80.0

var current_theme

onready var NeutralTheme = $NeutralTheme
onready var UpbeatTheme = $UpbeatTheme
onready var DownbeatTheme = $DownbeatTheme

signal beat(position)
signal measure(position)


func _ready() -> void:
	neutral()
	sec_per_beat = 60.0 / bpm


func play():
	NeutralTheme.play()
	UpbeatTheme.play()
	DownbeatTheme.play()


func stop():
	NeutralTheme.stop()
	UpbeatTheme.stop()
	DownbeatTheme.stop()


func seek(to_position):
	NeutralTheme.seek(to_position)
	UpbeatTheme.seek(to_position)
	DownbeatTheme.seek(to_position)


func _physics_process(_delta: float) -> void:
	if current_theme.playing:
		song_position += _delta
		#song_position = current_theme.get_playback_position() + AudioServer.get_time_since_last_mix()
		#song_position -= AudioServer.get_output_latency()
		var corrected_song_position = song_position + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
		song_position_in_beats = int(floor(corrected_song_position / sec_per_beat)) + beats_before_start
		_report_beat()


func _report_beat():
	#print(str(song_position_in_beats))
	if last_reported_beat < song_position_in_beats:
		if measure > measures:
			measure = 1
		emit_signal("beat", song_position_in_beats)
		emit_signal("measure", measure)
		last_reported_beat = song_position_in_beats
		measure += 1


func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()


func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth)
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)


func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset

	measure = beat % measures


func _on_StartTimer_timeout() -> void:
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()


func neutral():
	print("Neutral")
	current_theme = NeutralTheme
	fade_themes(max_volume, mute_volume, mute_volume)


func upbeat():
	print("Upbeat")
	current_theme = UpbeatTheme
	fade_themes(mute_volume, max_volume, mute_volume)


func downbeat():
	print("Downbeat")
	current_theme = DownbeatTheme
	fade_themes(mute_volume, mute_volume, max_volume)


func fade_themes(neutral, upbeat, downbeat):
	NeutralTheme.volume_db = neutral
	UpbeatTheme.volume_db = upbeat
	DownbeatTheme.volume_db = downbeat


func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.scancode == KEY_A:
			fade_themes(max_volume, mute_volume, mute_volume)
		if event.is_pressed() and event.scancode == KEY_S:
			fade_themes(mute_volume, max_volume, mute_volume)
		if event.is_pressed() and event.scancode == KEY_D:
			fade_themes(mute_volume, mute_volume, max_volume)
		
