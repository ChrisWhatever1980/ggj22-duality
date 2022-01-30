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
var previous_rhyme_idx = 0

var note = load("res://Note.tscn")
onready var InfoLabel = $InfoContainer/InfoLabel

onready var Word1 = $Word1
onready var Word2 = $Word2
onready var Word3 = $Word3
onready var Word4 = $Word4

var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 0
var spawn_4_beat = 1

var monster
onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

	select_rhymes(Word1.word_label)
	select_rhymes(Word2.word_label)
	select_rhymes(Word3.word_label)
	select_rhymes(Word4.word_label)

	InfoLabel.visible = false
	
	# instantiate monster
	var rand_monster = randi() % 10
	monster = load("res://monsters/Monster" + str(rand_monster) + ".tscn").instance()
	add_child(monster)
	monster.name = "Monster"
	monster.position = Vector2(90, 90)
	monster.scale = Vector2.ONE * 7

	$Conductor.play()


func monster_hit():
	$MonsterTween.interpolate_property(monster, "modulate", Color.white, Color.red, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	monster.rotation_degrees = -20
	$MonsterTween.start()
	yield(get_tree().create_timer(0.2), "timeout")
	$MonsterTween.interpolate_property(monster, "modulate", Color.red, Color.white, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	monster.rotation_degrees = 0
	$MonsterTween.start()

	# player jump
	$PlayerTween.interpolate_property(player, "position:y", 500, 450, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$PlayerTween.start()
	yield(get_tree().create_timer(0.2), "timeout")
	$PlayerTween.interpolate_property(player, "position:y", 450, 500, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$PlayerTween.start()


func player_hit():

	$PlayerTween.interpolate_property(player, "modulate", Color.white, Color.red, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	player.rotation_degrees = 20
	$PlayerTween.start()
	yield(get_tree().create_timer(0.2), "timeout")
	$PlayerTween.interpolate_property(player, "modulate", Color.red, Color.white, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	player.rotation_degrees = 0
	$PlayerTween.start()

	# monster jump
	$MonsterTween.interpolate_property(monster, "position:y", 90, 50, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$MonsterTween.start()
	yield(get_tree().create_timer(0.2), "timeout")
	$MonsterTween.interpolate_property(monster, "position:y", 50, 90, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$MonsterTween.start()


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
	elif event.is_action_pressed("key_2"):
		pressed_rhyme = Word2.word_label.text
		Word2.hit()
	elif event.is_action_pressed("key_3"):
		pressed_rhyme = Word3.word_label.text
		Word3.hit()
	elif event.is_action_pressed("key_4"):
		pressed_rhyme = Word4.word_label.text
		Word4.hit()

	if pressed_rhyme != "":
		$Terminator.handle_rhyme(pressed_rhyme)


func select_rhymes(label):
	var pair = RhymeManager.get_random_pair()
	label.text = pair[0]
	RhymeManager.battle_rhymes.append(pair)


func _on_Conductor_beat(position) -> void:
	song_position_in_beats = position

	#print(str(song_position_in_beats))

	if song_position_in_beats == 1:
		show_info_label("Get ready!")

	if song_position_in_beats == 4:
		show_info_label("3")

	if song_position_in_beats == 8:
		show_info_label("2")

	if song_position_in_beats == 12:
		show_info_label("1")

	if song_position_in_beats == 16:
		hide_info_label()


func _on_Conductor_measure(position) -> void:

	var enemy = $EnemyHealth.health / $EnemyHealth.max_health
	if enemy < 0.25:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	else:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 1

	if song_position_in_beats > 12:
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

		var total_rhymes = RhymeManager.battle_rhymes.size()
		var rhyme_idx = ((previous_rhyme_idx + randi() % total_rhymes) - 1) % total_rhymes
		var rhyme = RhymeManager.battle_rhymes[rhyme_idx][1]
		previous_rhyme_idx = rhyme_idx

		add_child(instance)

		var start_pos = $EnemyHealth.position
		var end_pos = $Terminator.position

		end_pos.x += (0.25 + randf() * 0.5) * $Terminator.get_width()

		var dist = (end_pos - start_pos).length()

		var speed = 2 * $Conductor.get_note_speed()

		instance.initialize(start_pos, end_pos, dist / speed, rhyme)


func emit_particles(by):
	if by > 0:
		$Left_Particles.amount = by * 20
		$Right_Particles.amount = by * 20
		$Top_Particles.amount = by * 20
		$Bottom_Particles.amount = by * 20

		$Left_Particles.emitting = true
		$Right_Particles.emitting = true
		$Top_Particles.emitting = true
		$Bottom_Particles.emitting = true


func increment_score(by):

	if by > 0:
		combo += 1
	else:
		combo -= 1

	combo = clamp(combo, -2, 2)

	if combo <= -2:
		$Conductor.downbeat()
	elif combo >= 2:
		$Conductor.upbeat()
	else:
		$Conductor.neutral()

	emit_particles(by)

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
		player_hit()
		$Camera.add_trauma(2.0)
	else:
		$EnemyHealth.take_damage(float(by))
		monster_hit()
		$Camera.add_trauma(1.0)

	if $EnemyHealth.health <= 0:
		# Player wins, exit battle
		$ExplodingSprite.initialize(monster.get_node("AnimatedSprite").frames.get_frame("default", 0))
		monster.visible = false
		show_info_label("You won!")
		game_over()

	if $PlayerHealth.health <= 0:
		# Player looses, exit battle
		$ExplodingSprite.position = player.position
		$ExplodingSprite.initialize(player.get_node("AnimatedSprite").frames.get_frame("default", 0))
		player.visible = false
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
	$InfoContainer/InfoLabel/AnimationPlayer.play("show_info")


func hide_info_label():
	InfoLabel.visible = false
	
