extends Node2D


onready var monsters = $monsters

export var BattleScene: PackedScene

var current_monster

var defeated_monsters = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	GameEvents.connect("unlock_word", self, "unlock_word")
	GameEvents.connect("start_battle", self, "start_battle")
	GameEvents.connect("finished_battle", self, "finished_battle")
	GameEvents.connect("mute_ambience", self, "mute_ambience")

	$OutdoorAmbience.play()

	show_dialog("Walk around with the cursor keys. Search for the lost words! Fight the monsters of silence!")


func _input(event):
	if Input.is_key_pressed(KEY_U):
		current_monster = $monsters/Monster
		defeated_monsters = 9
		finished_battle(true)
		


func mute_ambience(mute):
	if mute:
		$OutdoorAmbience.volume_db = -80.0
	else:
		$OutdoorAmbience.volume_db = 0.0


func start_battle(monster):
	
	if $Player.collected_words.size() <= 2:
		show_dialog("You don't have the words yet! Look for more words against the silence!")
	else:
		current_monster = monster
		var battle = BattleScene.instance()
		add_child(battle)
		battle.initialize(monster, $Player.collected_words)
		#$CameraTween.interpolate_property($Player/Camera2D, "zoom", Vector2.ONE * 0.5, Vector2.ONE * 0.1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)


func finished_battle(player_won):
	if player_won:
		print("finished_battle: remove monster")
		current_monster.visible = false
		current_monster.queue_free()
		current_monster = null
		defeated_monsters += 1
	#$CameraTween.interpolate_property($Player/Camera2D, "zoom", Vector2.ONE * 0.1, Vector2.ONE * 0.5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)

	if defeated_monsters >= 10:
		show_dialog("You defeated the silence and have freed the land. Rejoice!")
		yield(get_tree().create_timer(5.0), "timeout")
		get_tree().quit()

	yield(get_tree().create_timer(2.0), "timeout")
	$Player/Camera2D.current = true


func show_dialog(text):
	$Player/Camera2D/DialogBox.show_dialog(text, "")


func unlock_word(text, word):
	$Player/Camera2D/DialogBox.show_dialog(text, word)
	$Player.word_collected(word)
	$WordCollectedSound.play()


func spawn_monsters():
	var lands = $TileMap.get_used_cells_by_id(12)
	for m in range(0, 10):
		var monster = load("res://monsters/Monster" + str(m) + ".tscn").instance()
		monsters.add_child(monster)
		monster.name = "Monster" + str(m)

		var rand_land = lands[randi() % lands.size()]
		var pos = $TileMap.to_global($TileMap.map_to_world(rand_land))

		monster.position = pos
		monster.scale = Vector2.ONE

		lands.erase(rand_land)
	pass
