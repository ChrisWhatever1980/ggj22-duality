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
onready var InfoLabel = $CenterContainer/InfoLabel

onready var Word1 = $Word1
onready var Word2 = $Word2
onready var Word3 = $Word3
onready var Word4 = $Word4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

	select_rhymes(Word1.word_label)
	select_rhymes(Word2.word_label)
	select_rhymes(Word3.word_label)
	select_rhymes(Word4.word_label)

	InfoLabel.visible = false

	show_info_label("Get ready!")
	yield(get_tree().create_timer(2.0), "timeout")
	show_info_label("3")
	yield(get_tree().create_timer(2.0), "timeout")
	show_info_label("2")
	$Conductor.play_with_beat_offset(0)
	yield(get_tree().create_timer(2.0), "timeout")
	show_info_label("1")


func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.scancode == KEY_SPACE:
			$Camera.add_trauma(1.0)
		if event.is_pressed() and event.scancode == KEY_V:
			$Camera.add_trauma(1.0)
		


func _unhandled_input(event: InputEvent) -> void:
	var pressed_rhyme = ""
	if event.is_action_pressed("key_1"):
		pressed_rhyme = Word1.word_label.text
		Word1.hit()
	if event.is_action_pressed("key_2"):
		pressed_rhyme = Word2.word_label.text
		Word2.hit()
	if event.is_action_pressed("key_3"):
		pressed_rhyme = Word3.word_label.text
		Word3.hit()
	if event.is_action_pressed("key_4"):
		pressed_rhyme = Word4.word_label.text
		Word4.hit()

	if pressed_rhyme != "":
		$Terminator.handle_input(pressed_rhyme)


func select_rhymes(label):
	var pair = RhymeManager.get_random_pair()
	label.text = pair[0]
	RhymeManager.battle_rhymes.append(pair)


func _on_Conductor_beat(position) -> void:
	song_position_in_beats = position


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
		var rhyme = RhymeManager.battle_rhymes[randi() % RhymeManager.battle_rhymes.size()][1]
		add_child(instance)
		instance.initialize($EnemyHealth.position, $PlayerHealth.position + Vector2(1, 0) * (randf() * $PlayerHealth/Bar.rect_size.x - $PlayerHealth/Bar.rect_size.x / 2), rhyme)


func increment_score(by):

	if by > 0:
		combo += 1
	else:
		combo -= 1

	combo = clamp(combo, -2, 2)

	if combo <= -2:
		# play downbeat
		$Conductor.downbeat()
	elif combo >= 2:
		#play upbeat
		$Conductor.upbeat()
	else:
		# play neutral
		$Conductor.neutral()

	if by == 3:
		great += 1
		$PerfectPlayer.play()
	if by == 2:
		good += 1
		$GoodPlayer.play()
	if by == 1:
		okay += 1
		$OkPlayer.play()
	else:
		missed += 1
		$MissedPlayer.play()

	if by == 0:
		$PlayerHealth.take_damage(1.0)
		$Camera.add_trauma(2.0)
	else:
		$EnemyHealth.take_damage(float(by))
		$Camera.add_trauma(1.0)

	if $EnemyHealth.health <= 0:
		# Player wins, exit battle
		show_info_label("You won!")
		game_over()
	if $PlayerHealth.health <= 0:
		# Player looses, exit battle
		show_info_label("You lost!")
		game_over()


func game_over():
	$Conductor.stop()

	var notes = get_tree().get_nodes_in_group("note")
	for this_note in notes:
		this_note.queue_free()

	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().quit()
	


func show_info_label(text):
	InfoLabel.visible = true
	InfoLabel.text = text
	yield(get_tree().create_timer(2.0), "timeout")
	InfoLabel.visible = false
