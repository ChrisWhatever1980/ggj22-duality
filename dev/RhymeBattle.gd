extends Node

var score = 0
var combo = 0
var max_combo = 0
var great = 0
var good = 0
var okay = 0
var missed = 0

var bpm = 115
var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm
var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 1
var spawn_4_beat = 0
var note = load("res://Note.tscn")
var selected_rhymes = []



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

	select_rhymes($HBoxContainer/Word1/Label)
	select_rhymes($HBoxContainer/Word2/Label)
	select_rhymes($HBoxContainer/Word3/Label)
	select_rhymes($HBoxContainer/Word4/Label)

	$Conductor.play_with_beat_offset(8)


func _unhandled_input(event: InputEvent) -> void:
	var pressed_rhyme = ""
	if event.is_action_pressed("key_1"):
		pressed_rhyme = $HBoxContainer/Word1/Label.text
	if event.is_action_pressed("key_2"):
		pressed_rhyme = $HBoxContainer/Word2/Label.text
	if event.is_action_pressed("key_3"):
		pressed_rhyme = $HBoxContainer/Word3/Label.text
	if event.is_action_pressed("key_4"):
		pressed_rhyme = $HBoxContainer/Word4/Label.text

	if pressed_rhyme != "":
		$Terminator.handle_input(pressed_rhyme)


func select_rhymes(label):
	var pair = RhymeManager.get_random_pair()
	label.text = pair[0]
	selected_rhymes.append(pair[1])


func _on_Conductor_beat(position) -> void:
	song_position_in_beats = position
#	if song_position_in_beats > 36:
#		spawn_1_beat = 1
#		spawn_2_beat = 1
#		spawn_3_beat = 1
#		spawn_4_beat = 1
#	if song_position_in_beats > 98:
#		spawn_1_beat = 2
#		spawn_2_beat = 0
#		spawn_3_beat = 1
#		spawn_4_beat = 0
#	if song_position_in_beats > 132:
#		spawn_1_beat = 0
#		spawn_2_beat = 2
#		spawn_3_beat = 0
#		spawn_4_beat = 2
#	if song_position_in_beats > 162:
#		spawn_1_beat = 2
#		spawn_2_beat = 2
#		spawn_3_beat = 1
#		spawn_4_beat = 1
#	if song_position_in_beats > 194:
#		spawn_1_beat = 2
#		spawn_2_beat = 2
#		spawn_3_beat = 1
#		spawn_4_beat = 2
#	if song_position_in_beats > 228:
#		spawn_1_beat = 0
#		spawn_2_beat = 2
#		spawn_3_beat = 1
#		spawn_4_beat = 2
#	if song_position_in_beats > 258:
#		spawn_1_beat = 1
#		spawn_2_beat = 2
#		spawn_3_beat = 1
#		spawn_4_beat = 2
#	if song_position_in_beats > 288:
#		spawn_1_beat = 0
#		spawn_2_beat = 2
#		spawn_3_beat = 0
#		spawn_4_beat = 2
#	if song_position_in_beats > 322:
#		spawn_1_beat = 3
#		spawn_2_beat = 2
#		spawn_3_beat = 2
#		spawn_4_beat = 1
#	if song_position_in_beats > 388:
#		spawn_1_beat = 1
#		spawn_2_beat = 0
#		spawn_3_beat = 0
#		spawn_4_beat = 0
#	if song_position_in_beats > 396:
#		spawn_1_beat = 0
#		spawn_2_beat = 0
#		spawn_3_beat = 0
#		spawn_4_beat = 0
#	if song_position_in_beats > 404:
#		#end
#		get_tree().quit()


func _on_Conductor_measure(position) -> void:
	if position == 1:
		spawn_notes(spawn_1_beat)
	elif position == 2:
		spawn_notes(spawn_2_beat)
	elif position == 3:
		spawn_notes(spawn_3_beat)
	elif position == 4:
		spawn_notes(spawn_4_beat)


func spawn_notes(to_spawn):
	if to_spawn > 0:
		var instance = note.instance()
		var rhyme = selected_rhymes[randi() % selected_rhymes.size()]
		instance.initialize($EnemyHealth.position, $PlayerHealth.position + Vector2(1, 0) * (randf() * $PlayerHealth/Bar.rect_size.x - $PlayerHealth/Bar.rect_size.x / 2), rhyme)
		add_child(instance)
	if to_spawn > 1:
		var instance = note.instance()
		instance.initialize()
		add_child(instance)


func increment_score(by):
	if by > 0:
		combo += 1
	else:
		combo = 0

	if by == 3:
		great += 1
		print("GREAT")
	if by == 2:
		good += 1
		print("GOOD")
	if by == 1:
		okay += 1
		print("OKAY")
	else:
		missed += 1
		print("MISSED")

	score += by * combo
	if combo > 0:
		if combo > max_combo:
			max_combo = combo
