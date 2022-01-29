extends Node


var rhymes = []
var battle_rhymes = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_rhymes()
	randomize()


func load_rhymes():
	var file = File.new()
	file.open("res://data/rhymes.csv", file.READ)
	while !file.eof_reached():
		var csv = file.get_csv_line ()
		if csv.size()>=2:
			if !(rhymes.has([csv[0], csv[1]]) or rhymes.has([csv[1], csv[0]])):
				rhymes.append([csv[0], csv[1]])
	file.close()


func compare_rhymes(pressed_rhyme, attack_rhyme):
	for rhyme in battle_rhymes:
		if (rhyme[0] == pressed_rhyme and rhyme[1] == attack_rhyme) or (rhyme[1] == pressed_rhyme and rhyme[0] == attack_rhyme):
			return true
	return false


func get_random_pair():
	var rand_rhyme = randi() % rhymes.size()
	return rhymes[rand_rhyme]


func get_random_rhyme():
	var rand_rhyme = randi() % rhymes.size()
	return rhymes[rand_rhyme][randi() % 2]
